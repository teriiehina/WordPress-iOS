#import "ErrorNotifyingService.h"
#import "WPError.h"

@implementation ErrorNotifyingService

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message withSupportButton:(BOOL)showSupport
{
    [WPError showAlertWithTitle:title message:message withSupportButton:showSupport okPressedBlock:nil];
}

@end
