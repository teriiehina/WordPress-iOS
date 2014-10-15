#import "WordPressComLoginService.h"
#import "WordPressComOAuthClient.h"

@implementation WordPressComLoginService

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                         success:(void (^)(NSString *authToken))success
                         failure:(void (^)(NSError *error))failure
{
    WordPressComOAuthClient *client = [WordPressComOAuthClient client];
    [client authenticateWithUsername:username
                            password:password
                             success:success
                             failure:failure];
}

@end
