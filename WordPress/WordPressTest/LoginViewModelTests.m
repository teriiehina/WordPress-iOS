#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LoginViewModel.h"
#import "ReachabilityService.h"

SpecBegin(LoginViewModelTests)

__block LoginViewModel *_loginViewModel;

beforeEach(^{
    _loginViewModel = [[LoginViewModel alloc] init];
});

NSString *username = @"username";
NSString *password = @"password";
NSString *siteUrl = @"randomsite.wordpress.com";

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
    
    id reachabilityServiceMock = [OCMockObject niceMockForClass:[ReachabilityService class]];
    
    beforeEach(^{
        _loginViewModel.reachabilityService = reachabilityServiceMock;
    });
  
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

SpecEnd