//
//  LoginViewModel.h
//  WordPress
//
//  Created by Sendhil Panchadsaram on 10/4/14.
//  Copyright (c) 2014 WordPress. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) BOOL signInEnabled;

- (void)signIn;

@end
