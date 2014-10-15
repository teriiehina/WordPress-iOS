#import <Foundation/Foundation.h>

@protocol WordPressComLoginServiceProtocol<NSObject>

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                         success:(void (^)(NSString *authToken))success
                         failure:(void (^)(NSError *error))failure;

@end

@interface WordPressComLoginService : NSObject<WordPressComLoginServiceProtocol>

@end
