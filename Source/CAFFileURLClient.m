//
//  CAFFileURLClient.m
//  Curiosity
//
//  Created by Matthew Thomas on 3/31/13.
//  Copyright (c) 2013 Matthew Thomas. All rights reserved.
//

#import "CAFFileURLClient.h"

@implementation CAFFileURLClient

- (void)getFileAtPath:(NSString *)path
              success:(void (^)(AFHTTPRequestOperation *operation, NSString *filename, NSString *fileContents))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getPath:path
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (success) {
                  success(nil, nil, nil);
              }
          }
          failure:failure];
}

@end
