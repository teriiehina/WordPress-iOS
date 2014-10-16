#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LoginViewModel.h"
#import "ReachabilityService.h"
#import "ErrorNotifyingService.h"
#import "WordPressComLoginService.h"

SpecBegin(LoginViewModelTests)

NSString *username = @"username";
NSString *password = @"password";
NSString *siteUrl = @"randomsite.wordpress.com";

id reachabilityServiceMock = [OCMockObject niceMockForClass:[ReachabilityService class]];
id errorNotifyingServiceMock = [OCMockObject niceMockForClass:[ErrorNotifyingService class]];
id wordpressComLoginServiceMock = [OCMockObject niceMockForClass:[WordPressComLoginService class]];

__block LoginViewModel *_loginViewModel;

beforeEach(^{
    _loginViewModel = [[LoginViewModel alloc] init];
    _loginViewModel.reachabilityService = reachabilityServiceMock;
    _loginViewModel.errorNotifiyingService = errorNotifyingServiceMock;
    _loginViewModel.wordpressComLoginService = wordpressComLoginServiceMock;
    _loginViewModel.setAuthenticatingBlock = ^(BOOL authenticating, NSString *message) {};
});

describe(@"Enabled status of the sign in button", ^{
    
    context(@"for a WordPress.com site", ^{
        
        beforeEach(^{
            _loginViewModel.userIsDotCom = YES;
        });
        
        it(@"should be disabled when all three fields are blank" , ^{
            _loginViewModel.username = @"";
            _loginViewModel.password = @"";
            _loginViewModel.siteUrl = @"";
            expect(_loginViewModel.signInEnabled).to.beFalsy();
        });
        
        it(@"should be disabled when password and siteurl are blank" , ^{
            _loginViewModel.username = username;
            _loginViewModel.password = @"";
            _loginViewModel.siteUrl = @"";
            expect(_loginViewModel.signInEnabled).to.beFalsy();
        });
        
        it(@"should be enabled when username and password are filled" , ^{
            _loginViewModel.username = username;
            _loginViewModel.password = password;
            _loginViewModel.siteUrl = @"";
            expect(_loginViewModel.signInEnabled).to.beTruthy();
        });
        
        it(@"should not be enabled when username and password are filled but authenticating is true", ^{
            _loginViewModel.username = username;
            _loginViewModel.password = password;
            _loginViewModel.siteUrl = @"";
            _loginViewModel.authenticating = YES;
            expect(_loginViewModel.signInEnabled).to.beFalsy();
        });
    });
    
    context(@"for a self hosted site", ^{
        
        beforeEach(^{
            _loginViewModel.userIsDotCom = NO;
        });
        
        it(@"should be disabled when all three fields are blank" , ^{
            _loginViewModel.username = @"";
            _loginViewModel.password = @"";
            _loginViewModel.siteUrl = @"";
            expect(_loginViewModel.signInEnabled).to.beFalsy();
        });
        
        it(@"should be disabled when password and siteurl are blank" , ^{
            _loginViewModel.username = username;
            _loginViewModel.password = @"";
            _loginViewModel.siteUrl = @"";
            expect(_loginViewModel.signInEnabled).to.beFalsy();
        });
        
        it(@"should be disabled when username and password are filled" , ^{
            _loginViewModel.username = username;
            _loginViewModel.password = password;
            _loginViewModel.siteUrl = @"";
            expect(_loginViewModel.signInEnabled).to.beFalsy();
        });
        
        it(@"should be enabled when username, password and siteUrl are filled" , ^{
            _loginViewModel.username = username;
            _loginViewModel.password = password;
            _loginViewModel.siteUrl = siteUrl;
            expect(_loginViewModel.signInEnabled).to.beTruthy();
        });
        
        it(@"should not be enabled when username, password and siteUrl are filled but authenticating is true" , ^{
            _loginViewModel.username = username;
            _loginViewModel.password = password;
            _loginViewModel.siteUrl = siteUrl;
            _loginViewModel.authenticating = YES;
            expect(_loginViewModel.signInEnabled).to.beFalsy();
        });
    });
});

describe(@"The forgot password button", ^{
    
    context(@"for a WordPress.com site", ^{
        
        beforeEach(^{
            _loginViewModel.userIsDotCom = YES;
        });
        
        it(@"should be visible", ^{
            
            __block BOOL hidden;
            [_loginViewModel.forgotPasswordHiddenSignal subscribeNext:^(NSNumber *forgotPasswordHidden){
                hidden = [forgotPasswordHidden boolValue];
            }];
            
            expect(hidden).to.beFalsy();
        });
        
        it(@"should not be visible when authenticating", ^{
            __block BOOL hidden;
            _loginViewModel.authenticating = YES;
            [_loginViewModel.forgotPasswordHiddenSignal subscribeNext:^(NSNumber *forgotPasswordHidden){
                hidden = [forgotPasswordHidden boolValue];
            }];
            
            expect(hidden).to.beTruthy();
        });
    });
    
    context(@"for a self hosted site", ^{
        beforeEach(^{
            _loginViewModel.userIsDotCom = NO;
        });
        
        it(@"should be hidden when the siteUrl is blank", ^{
            _loginViewModel.siteUrl = @"";
            
            __block BOOL hidden;
            [_loginViewModel.forgotPasswordHiddenSignal subscribeNext:^(NSNumber *forgotPasswordHidden){
                hidden = [forgotPasswordHidden boolValue];
            }];
            
            expect(hidden).to.beTruthy();
        });
        
        it(@"should not be hidden when the siteUrl is filled", ^{
            _loginViewModel.siteUrl = siteUrl;
            
            __block BOOL hidden;
            [_loginViewModel.forgotPasswordHiddenSignal subscribeNext:^(NSNumber *forgotPasswordHidden){
                hidden = [forgotPasswordHidden boolValue];
            }];
            
            expect(hidden).to.beFalsy();
        });
        
        it(@"should be hidden when the site url is filled and user is authenticating", ^{
            _loginViewModel.siteUrl = siteUrl;
            _loginViewModel.authenticating = YES;
            
            __block BOOL hidden;
            [_loginViewModel.forgotPasswordHiddenSignal subscribeNext:^(NSNumber *forgotPasswordHidden){
                hidden = [forgotPasswordHidden boolValue];
            }];
            
            expect(hidden).to.beTruthy();
        });
    });
    
});

describe(@"-signIn", ^{
    
    context(@"internet availability", ^{
        it(@"should check if the internet is available", ^{
            [[reachabilityServiceMock expect] isInternetReachable];
            [_loginViewModel signIn];
            [reachabilityServiceMock verify];
        });
        
        it(@"should display a message about the internet being offline when it is", ^{
            [[[reachabilityServiceMock stub] andReturnValue:OCMOCK_VALUE(NO)] isInternetReachable];
            [[reachabilityServiceMock expect] showAlertNoInternetConnection];
            [_loginViewModel signIn];
            [reachabilityServiceMock verify];
        });
    });
    
    context(@"field validation", ^{
        
        beforeEach(^{
            _loginViewModel.username = username;
            _loginViewModel.password = password;
            _loginViewModel.userIsDotCom = YES;
        });
        
        void (^setupLoginErrorBlock)(void) = ^{
            [[errorNotifyingServiceMock expect] showAlertWithTitle:[OCMArg any] message:[OCMArg any] withSupportButton:NO];
        };
        
        context(@"for WordPress.com users", ^{
            
            it(@"should display an error message if username is blank", ^{
                setupLoginErrorBlock();
                _loginViewModel.username = nil;
                [_loginViewModel signIn];
                [errorNotifyingServiceMock verify];
            });
            
            it(@"should display an error message if password is blank", ^{
                setupLoginErrorBlock();
                _loginViewModel.password = nil;
                [_loginViewModel signIn];
                [errorNotifyingServiceMock verify];
            });
        });
        
        context(@"for self hosted users", ^{
            beforeEach(^{
                _loginViewModel.userIsDotCom = NO;
                _loginViewModel.siteUrl = siteUrl;
            });
            
            it(@"should display an error message if the site url is blank", ^{
                setupLoginErrorBlock();
                _loginViewModel.siteUrl = nil;
                [_loginViewModel signIn];
                [errorNotifyingServiceMock verify];
            });
            
            it(@"should display an error message if the site url is invalid", ^{
                setupLoginErrorBlock();
                _loginViewModel.siteUrl = @"@@#%A$^@#$@#";
                [_loginViewModel signIn];
                [errorNotifyingServiceMock verify];
            });
        });
    });
    
    context(@"with valid parameters for Wordpress.com", ^{
        
        beforeEach(^{
            _loginViewModel.username = username;
            _loginViewModel.password = password;
            _loginViewModel.userIsDotCom = YES;
        });
    
        it(@"should tell the view to toggle the authentication status", ^{
            __block BOOL callbackExecuted = NO;
            _loginViewModel.setAuthenticatingBlock = ^(BOOL authenticating, NSString *message) {
                callbackExecuted = YES;
                expect(authenticating).to.beTruthy();
            };
            
            [_loginViewModel signIn];
            expect(callbackExecuted).to.beTruthy();
        });
        
        it(@"should attempt to sign into the Wordpress.com Login Service", ^{
            [[wordpressComLoginServiceMock expect] authenticateWithUsername:[OCMArg any] password:[OCMArg any] success:[OCMArg any] failure:[OCMArg any]];
            [_loginViewModel signIn];
            [wordpressComLoginServiceMock verify];
        });
    });
   
    
});

SpecEnd