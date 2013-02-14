//
//  CAFGitHubClient.h
//  CAFGitHub
//
//  Created by Matthew Thomas on 12/9/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "CAFGitHubUser.h"
#import "CAFGist.h"


OBJC_EXPORT NSString *const CAFGitHubErrorDomain;


@interface CAFGitHubClient : AFHTTPClient

/* Gets all public gists
 */
- (void)getPublicGistsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, NSArray *gists))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/* Get gists for a specific user
 */
- (void)getGistsForUsername:(NSString *)username
                    success:(void (^)(AFHTTPRequestOperation *operation, NSArray *gists))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/* Get gist specified by ID
 */
- (void)getGistWithID:(NSUInteger)gistID
              success:(void (^)(AFHTTPRequestOperation *operation, CAFGist *gist))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/* Create an OAuth token for a user
 */
- (void)createOAuthTokenWithUsername:(NSString *)username
                            password:(NSString *)password
                            clientID:(NSString *)clientID
                        clientSecret:(NSString *)clientSecret
                              scopes:(NSArray *)scopes
                             success:(void (^)(AFHTTPRequestOperation *operation, NSString *oAuthToken))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark -
#pragma mark Methods requiring authentication
#pragma mark Requires 'gist' scope
/* Return Authenticated user's gists
 */
- (void)getGistsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, NSArray *gists))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/* Return Authenticated user's favorites
 */
- (void)getStarredGistsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, NSArray *gists))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark - Requires 'user' scope
/* Return user info
 */
- (void)getUserWithSuccess:(void (^)(AFHTTPRequestOperation *operation, CAFGitHubUser *user))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
