//
//  LoginViewModel.m
//  WordPress
//
//  Created by Sendhil Panchadsaram on 10/4/14.
//  Copyright (c) 2014 WordPress. All rights reserved.
//

#import "LoginViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

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
    RAC(self, signInEnabled) = [[RACSignal combineLatest:@[RACObserve(self, username), RACObserve(self, password)]] reduceEach:^id(NSString *username, NSString *password){
        return @([username length] > 0 && [password length] > 0);
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
