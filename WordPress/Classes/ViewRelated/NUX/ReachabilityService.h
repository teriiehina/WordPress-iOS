#import <Foundation/Foundation.h>

@protocol ReachabilityServiceProtocol <NSObject>

- (BOOL)isInternetReachable;
- (void)showAlertNoInternetConnection;

@end

@interface ReachabilityService : NSObject <ReachabilityServiceProtocol>

@end
