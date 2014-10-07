#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LoginViewModel.h"

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
        
        it(@"should be hidden when the siteUrl is filled", ^{
            _loginViewModel.siteUrl = siteUrl;
            
            __block BOOL hidden;
            [_loginViewModel.forgotPasswordHiddenSignal subscribeNext:^(NSNumber *forgotPasswordHidden){
                hidden = [forgotPasswordHidden boolValue];
            }];
            
            expect(hidden).to.beFalsy();
        });
    });
    
});

SpecEnd