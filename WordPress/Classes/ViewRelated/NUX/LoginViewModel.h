#import <Foundation/Foundation.h>

@class RACSignal;

@protocol ReachabilityServiceProtocol;
@protocol ErrorNotifyingServiceProtocol;
@protocol WordPressComLoginServiceProtocol;

@interface LoginViewModel : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *siteUrl;
@property (nonatomic, assign) BOOL authenticating;
@property (nonatomic, assign) BOOL signInEnabled;
@property (nonatomic, assign) BOOL userIsDotCom;
@property (nonatomic, readonly) RACSignal *validSignInSignal;
@property (nonatomic, readonly) RACSignal *forgotPasswordHiddenSignal;

// Services
@property (nonatomic, strong) id<ReachabilityServiceProtocol> reachabilityService;
@property (nonatomic, strong) id<ErrorNotifyingServiceProtocol> errorNotifiyingService;
@property (nonatomic, strong) id<WordPressComLoginServiceProtocol> wordpressComLoginService;

// Callbacks
@property (nonatomic, copy) void (^setAuthenticatingBlock)(BOOL authenticating, NSString * message);

-(void)signIn;

@end
