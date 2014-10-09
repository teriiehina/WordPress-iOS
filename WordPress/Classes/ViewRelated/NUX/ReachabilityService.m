#import "ReachabilityService.h"
#import "ReachabilityUtils.h"

@implementation ReachabilityService

- (BOOL)isInternetReachable
{
    return [ReachabilityUtils isInternetReachable];
}

- (void)showAlertNoInternetConnection
{
    return [ReachabilityUtils showAlertNoInternetConnection];
}

@end
