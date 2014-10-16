#import "LoginViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ReachabilityService.h"
#import "ErrorNotifyingService.h"
#import "WordPressComLoginService.h"

@interface LoginViewModel()

@property (nonatomic, strong) RACSignal *validSignInSignal;
@property (nonatomic, strong) RACSignal *forgotPasswordHiddenSignal;

@end

@implementation LoginViewModel

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)verifySignInServices
{
    NSAssert(self.reachabilityService !=  nil, @"");
    NSAssert(self.errorNotifiyingService !=  nil, @"");
    NSAssert(self.setAuthenticatingBlock != nil, @"");
    NSAssert(self.wordpressComLoginService != nil, @"");
}

- (void)setup
{
    self.validSignInSignal = [[RACSignal combineLatest:@[RACObserve(self, username), RACObserve(self, password), RACObserve(self, siteUrl), RACObserve(self, userIsDotCom), RACObserve(self, authenticating)]] reduceEach:^id(NSString *username, NSString *password, NSString *siteUrl, NSNumber *userIsDotCom, NSNumber *authenticating){
        if ([authenticating boolValue]) {
            return @(NO);
        }
        
        BOOL areDotComFieldsFilled = [username length] > 0 && [password length] > 0;
        if ([userIsDotCom boolValue]) {
            return @(areDotComFieldsFilled);
        } else {
            return @(areDotComFieldsFilled && [siteUrl length] > 0);
        }
    }];
    
    [self.validSignInSignal subscribeNext:^(NSNumber *enabled){
        self.signInEnabled = [enabled boolValue];
    }];
    
    self.forgotPasswordHiddenSignal = [[RACSignal combineLatest:@[RACObserve(self, userIsDotCom), RACObserve(self, siteUrl), RACObserve(self, authenticating)]] reduceEach:^(NSNumber *userIsDotCom, NSString *siteUrl, NSNumber *authenticating){
        if ([authenticating boolValue]) {
            return @(YES);
        }
        return @(!([userIsDotCom boolValue] || siteUrl.length != 0));
    }];
}

- (void)signIn
{
    [self verifySignInServices];
    
    if (![self.reachabilityService isInternetReachable]) {
        [self.reachabilityService showAlertNoInternetConnection];
    }
    
    if (![self areFieldsValid]) {
        [self.errorNotifiyingService showAlertWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Please fill out all the fields", nil) withSupportButton:NO];
    }
    
#warning Add `isUsernameReserved` checks
   
    self.setAuthenticatingBlock(YES, NSLocalizedString(@"Authenticating", nil));
    
    if (self.userIsDotCom || [self isUrlWPCom:self.siteUrl]) {
        [self signInToDotCom];
    }
    
    [self checkIfSiteIsSelfHosted];
}

- (BOOL)isUrlWPCom:(NSString *)url
{
    if (url.length == 0) {
        return NO;
    }
    
    NSRegularExpression *protocol = [NSRegularExpression regularExpressionWithPattern:@"wordpress\\.com/?$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *result = [protocol matchesInString:[url trim] options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [[url trim] length])];

    return [result count] != 0;
}

- (void)signInToDotCom
{
    self.setAuthenticatingBlock(YES, NSLocalizedString(@"Authenticating", nil));
    
    void (^successCallback)(NSString *) = ^void(NSString *authToken){
        self.setAuthenticatingBlock(YES, NSLocalizedString(@"Getting account information", nil));
        WPAccount *account = [self.wordpressComLoginService createAccountWithUsername:self.username password:self.password authToken:authToken];
#warning Add Blog Syncing
    };
    
    void (^failureCallback)(NSError *) = ^void(NSError *error){
#warning Display Error Message
        self.setAuthenticatingBlock(NO, nil);
        NSLog(@"Failed to get auth token %@", [error localizedDescription]);
    };
    
    [self.wordpressComLoginService authenticateWithUsername:self.username
                                                   password:self.password
                                                    success:successCallback
                                                    failure:failureCallback];
}

- (void)checkIfSiteIsSelfHosted
{
    
}

- (BOOL)areFieldsValid
{
    if (self.userIsDotCom) {
        return [self areDotComFieldsFilled];
    } else {
        if ([self areSelfHostedFieldsFilled]) {
            return [self isUrlValid];
        } else {
            return NO;
        }
    }
}

- (BOOL)areDotComFieldsFilled
{
    return [self.username length] > 0 && [self.password length] > 0;
}

- (BOOL)areSelfHostedFieldsFilled
{
    return [self areDotComFieldsFilled] && [self.siteUrl length] > 0;
}

- (BOOL)isUrlValid
{
    if ([self.siteUrl length] == 0) {
        return NO;
    }
    NSURL *siteURL = [NSURL URLWithString:self.siteUrl];
    return siteURL != nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Username : %@, Password : %@", self.username, self.password];
}

@end
