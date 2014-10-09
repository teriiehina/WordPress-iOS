#import <Foundation/Foundation.h>

@protocol ErrorNotifyingServiceProtocol<NSObject>

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message withSupportButton:(BOOL)showSupport;

@end

@interface ErrorNotifyingService : NSObject<ErrorNotifyingServiceProtocol>

@end
