#import <Foundation/Foundation.h>

@class WPAccount;
@protocol WordPressLoginServiceProtocol<NSObject>

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                         success:(void (^)(NSString *authToken))success
                         failure:(void (^)(NSError *error))failure;
- (WPAccount *)createAccountWithUsername:(NSString *)username
                                password:(NSString *)password
                               authToken:(NSString *)authToken;

@end

@interface WordPressComLoginService : NSObject<WordPressLoginServiceProtocol>

@end
