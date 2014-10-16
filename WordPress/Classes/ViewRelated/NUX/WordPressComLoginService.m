#import "WordPressComLoginService.h"
#import "WordPressComOAuthClient.h"
#import "ContextManager.h"
#import "AccountService.h"

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

- (WPAccount *)createAccountWithUsername:(NSString *)username
                                password:(NSString *)password
                               authToken:(NSString *)authToken
{
    NSManagedObjectContext *context = [[ContextManager sharedInstance] mainContext];
    AccountService *accountService = [[AccountService alloc] initWithManagedObjectContext:context];

    return [accountService createOrUpdateWordPressComAccountWithUsername:username password:password authToken:authToken];
}

@end
