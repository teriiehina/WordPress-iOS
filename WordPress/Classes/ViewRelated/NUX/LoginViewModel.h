#import <Foundation/Foundation.h>

@class RACSignal;

@protocol ReachabilityServiceProtocol;
@protocol ErrorNotifyingServiceProtocol;

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
@property (nonatomic, weak) id<ReachabilityServiceProtocol> reachabilityService;
@property (nonatomic, weak) id<ErrorNotifyingServiceProtocol> errorNotifiyingService;

-(void)signIn;

@end
