//
//  CAFGitHubClient.m
//  CAFGitHub
//
//  Created by Matthew Thomas on 12/9/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import "CAFGitHubClient.h"


NSString *const CAFGitHubErrorDomain = @"CAFGitHubErrorDomain";


static NSString *const CAFGitHubClientBaseURL = @"https://api.github.com";

@implementation CAFGitHubClient

- (instancetype)init
{
    return [self initWithBaseURL:[NSURL URLWithString:CAFGitHubClientBaseURL]];
}


- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        self.parameterEncoding = AFJSONParameterEncoding;
    }
    return self;
}


- (void)getPublicGistsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, NSArray *gists))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getPath:@"/gists/public"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSArray *gists = @[];
              if ([responseObject isKindOfClass:[NSArray class]]) {
                  NSArray *responseJSON = (NSArray *)responseObject;
                  NSMutableArray *gistModels = [[NSMutableArray alloc] initWithCapacity:[responseJSON count]];
                  for (NSDictionary *dictionary in responseJSON) {
                      CAFGist *gist = [CAFGist modelWithExternalRepresentation:dictionary];
                      if (gist) {
                          [gistModels addObject:gist];
                      }
                  }
                  gists = [gistModels copy];
              }
              success(operation, gists);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(operation, error);
          }];
}


- (void)getGistsForUsername:(NSString *)username
                    success:(void (^)(AFHTTPRequestOperation *operation, NSArray *gists))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
}


- (void)getGistWithID:(NSUInteger)gistID
              success:(void (^)(AFHTTPRequestOperation *operation, CAFGist *gist))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
}


- (void)createOAuthTokenWithUsername:(NSString *)username
                            password:(NSString *)password
                            clientID:(NSString *)clientID
                        clientSecret:(NSString *)clientSecret
                              scopes:(NSArray *)scopes
                             success:(void (^)(AFHTTPRequestOperation *operation, NSString *oAuthToken))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary *parameters = @{
        @"scopes" : scopes,
        @"client_id": clientID,
        @"client_secret": clientSecret,
    };
    
    [self setAuthorizationHeaderWithUsername:username password:password];
    [self postPath:@"/authorizations"
        parameters:parameters
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               
               NSString *token = nil;
               if ([responseObject isKindOfClass:[NSDictionary class]]) {
                   NSDictionary *dictionary = (NSDictionary *)responseObject;
                   token = dictionary[@"token"];
               }

               if ([token length] > 0) {
                   success(operation, token);
               } else {
                   failure(operation,
                           [[NSError alloc] initWithDomain:CAFGitHubErrorDomain
                                                      code:NSURLErrorCannotParseResponse
                                                  userInfo:@{
                                 NSLocalizedDescriptionKey: @"No valid token in response"
                            }]);
               }
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }];
}


- (void)getGistsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, NSArray *gists))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getPath:@"/gists"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSArray *gists = @[];
              if ([responseObject isKindOfClass:[NSArray class]]) {
                  NSArray *responseJSON = (NSArray *)responseObject;
                  NSMutableArray *gistModels = [[NSMutableArray alloc] initWithCapacity:[responseJSON count]];
                  for (NSDictionary *dictionary in responseJSON) {
                      CAFGist *gist = [CAFGist modelWithExternalRepresentation:dictionary];
                      if (gist) {
                          [gistModels addObject:gist];
                      }
                  }
                  gists = [gistModels copy];
              }
              success(operation, gists);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(operation, error);
          }];
}


- (void)getStarredGistsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, NSArray *gists))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getPath:@"/gists/starred"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSArray *gists = @[];
              if ([responseObject isKindOfClass:[NSArray class]]) {
                  NSArray *responseJSON = (NSArray *)responseObject;
                  NSMutableArray *gistModels = [[NSMutableArray alloc] initWithCapacity:[responseJSON count]];
                  for (NSDictionary *dictionary in responseJSON) {
                      CAFGist *gist = [CAFGist modelWithExternalRepresentation:dictionary];
                      if (gist) {
                          [gistModels addObject:gist];
                      }
                  }
                  gists = [gistModels copy];
              }
              success(operation, gists);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(operation, error);
          }];
}


- (void)getUserWithSuccess:(void (^)(AFHTTPRequestOperation *operation, CAFGitHubUser *user))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getPath:@"/user"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              CAFGitHubUser *user = nil;
              if ([responseObject isKindOfClass:[NSDictionary class]]) {
                  NSDictionary *responseJSON = (NSDictionary *)responseObject;
                  user = [CAFGitHubUser modelWithExternalRepresentation:responseJSON];
              }
              
              if (user) {
                  success(operation, user);
              } else {
                  failure(operation, [[NSError alloc] initWithDomain:CAFGitHubErrorDomain
                                                                code:NSURLErrorCannotParseResponse
                                                            userInfo:@{
                                           NSLocalizedDescriptionKey:@"Cannot create user object with response"
                                      }]);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(operation, error);
          }];
}


#pragma mark - AFHTTPClient
- (void)setAuthorizationHeaderWithToken:(NSString *)token
{
    [self setDefaultHeader:@"Authorization"
                     value:[NSString stringWithFormat:@"token %@", token]];
}

@end
