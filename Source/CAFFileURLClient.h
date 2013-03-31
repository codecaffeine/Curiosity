//
//  CAFFileURLClient.h
//  Curiosity
//
//  Created by Matthew Thomas on 3/31/13.
//  Copyright (c) 2013 Matthew Thomas. All rights reserved.
//

#import "AFHTTPClient.h"

@interface CAFFileURLClient : AFHTTPClient

- (void)getFileAtPath:(NSString *)path
        success:(void (^)(AFHTTPRequestOperation *operation, NSString *filename, NSString *fileContents))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
