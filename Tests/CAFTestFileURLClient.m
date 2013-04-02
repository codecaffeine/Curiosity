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
#import <AFNetworking/AFNetworking.h>

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
    
    __block NSError *returnedError = nil;
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


- (void)test200CallsSuccess
{
    [CAFMockURLConnection setResponseWithStatusCode:200
                                       headerFields:nil
                                           bodyData:nil];
    
    CAFFileURLClient *client = [[CAFFileURLClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://foobar.com"]];
    
    __block BOOL successCalled = NO;
    [client getFileAtPath:@"something.txt"
                  success:^(AFHTTPRequestOperation *operation, NSString *filename, NSString *fileContents) {
                      successCalled = YES;
                  }
                  failure:nil];
    // Run loop
    NSDate *until = [NSDate dateWithTimeIntervalSinceNow:0.5];
    while (!successCalled && ([until compare:[NSDate date]] == NSOrderedDescending)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:until];
    }
    STAssertTrue(successCalled, @"Success should have been called");
}


- (void)testSuccesResponseHasOperationFilenameAndFileContents
{
    [CAFMockURLConnection setResponseWithStatusCode:200
                                       headerFields:nil
                                           bodyData:[@"TestResponse" dataUsingEncoding:NSUTF8StringEncoding]];
    
    CAFFileURLClient *client = [[CAFFileURLClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://foobar.com"]];
    
    __block AFHTTPRequestOperation *expectedOperation = nil;
    __block NSString *expectedFilename = nil;
    __block NSString *expectedFileContents = nil;
    [client getFileAtPath:@"something.txt"
                  success:^(AFHTTPRequestOperation *operation, NSString *filename, NSString *fileContents) {
                      expectedOperation = operation;
                      expectedFilename = filename;
                      expectedFileContents = fileContents;
                  }
                  failure:nil];
    // Run loop
    NSDate *until = [NSDate dateWithTimeIntervalSinceNow:0.5];
    while (!expectedOperation && !expectedFilename && !expectedFileContents && ([until compare:[NSDate date]] == NSOrderedDescending)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:until];
    }
    STAssertNotNil(expectedOperation, @"Should have found expectedOperation");
    STAssertNotNil(expectedFilename, @"Should have found expectedFilename");
    STAssertNotNil(expectedFileContents, @"Should have found expectedFileContents");
}

@end
