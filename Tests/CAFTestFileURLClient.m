//
//  CAFTestFileURLClient.m
//  Curiosity
//
//  Created by Matthew Thomas on 3/31/13.
//  Copyright (c) 2013 Matthew Thomas. All rights reserved.
//

#import "CAFTestFileURLClient.h"
#import "CAFMockURLConnection.h"
#import "CAFFileURLClient.h"

@implementation CAFTestFileURLClient

- (void)setUp
{
    [super setUp];
    [NSURLProtocol registerClass:[CAFMockURLConnection class]];
}


- (void)tearDown
{
    [NSURLProtocol unregisterClass:[CAFMockURLConnection class]];
    [super tearDown];
}


- (void)test404ReturnsError
{
    [CAFMockURLConnection setResponseWithStatusCode:404
                                       headerFields:nil
                                           bodyData:nil];
    
    CAFFileURLClient *client = [[CAFFileURLClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://foobar.com"]];
    
    __block NSError *returnedError;
    [client getFileAtPath:@"something.txt"
                  success:nil
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      returnedError = error;
                  }];
    // Run loop
    NSDate *until = [NSDate dateWithTimeIntervalSinceNow:0.5];
    while (!returnedError && ([until compare:[NSDate date]] == NSOrderedDescending)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:until];
    }
    STAssertNotNil(returnedError, @"Error should not be nil");
}

@end
