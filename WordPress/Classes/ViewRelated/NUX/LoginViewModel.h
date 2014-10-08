//
//  LoginViewModel.h
//  WordPress
//
//  Created by Sendhil Panchadsaram on 10/4/14.
//  Copyright (c) 2014 WordPress. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface LoginViewModel : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *siteUrl;
@property (nonatomic, assign) BOOL authenticating;
@property (nonatomic, assign) BOOL signInEnabled;
@property (nonatomic, assign) BOOL userIsDotCom;
@property (nonatomic, readonly) RACSignal *validSignInSignal;
@property (nonatomic, readonly) RACSignal *forgotPasswordHiddenSignal;

@end
