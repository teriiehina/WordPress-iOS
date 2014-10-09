#import "LoginViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ReachabilityService.h"

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
    NSAssert(self.reachabilityService != nil, @"Reachability Service should be set");
    
    if (![self.reachabilityService isInternetReachable]) {
        [self.reachabilityService showAlertNoInternetConnection];
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Username : %@, Password : %@", self.username, self.password];
}

@end
