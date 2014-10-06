//
//  LoginViewModel.m
//  WordPress
//
//  Created by Sendhil Panchadsaram on 10/4/14.
//  Copyright (c) 2014 WordPress. All rights reserved.
//

#import "LoginViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LoginViewModel()

@property (nonatomic, strong) RACSignal *validSignInSignal;

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
    self.validSignInSignal = [[RACSignal combineLatest:@[RACObserve(self, username), RACObserve(self, password), RACObserve(self, siteUrl), RACObserve(self, userIsDotCom)]] reduceEach:^id(NSString *username, NSString *password, NSString *siteUrl, NSNumber *userIsDotCom){
        BOOL areDotComFieldsFilled = [username length] > 0 && [password length] > 0;
        if ([userIsDotCom boolValue]) {
            return @(areDotComFieldsFilled);
        } else {
            return @(areDotComFieldsFilled && [siteUrl length] > 0);
        }
    }];
    [self.validSignInSignal subscribeNext:^(NSNumber *enabled){
        self.signInEnabled = [enabled boolValue];
        NSLog(@"VALID SIGN IN SIGNAL : %d", [enabled boolValue]);
    }];
}

- (void)signIn
{
    NSLog(@"SIGN IN");
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Username : %@, Password : %@", self.username, self.password];
}

@end
