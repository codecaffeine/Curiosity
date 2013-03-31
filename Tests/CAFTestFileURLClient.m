//
//  CAFTestFileURLClient.m
//  Curiosity
//
//  Created by Matthew Thomas on 3/31/13.
//  Copyright (c) 2013 Matthew Thomas. All rights reserved.
//

#import "CAFTestFileURLClient.h"
#import "CAFMockURLConnection.h"

@implementation CAFTestFileURLClient

- (void)setUp
{
    [NSURLProtocol registerClass:[CAFMockURLConnection class]];
}


- (void)tearDown
{
    [NSURLProtocol unregisterClass:[CAFMockURLConnection class]];
}


- (void)test404ReturnsError
{
    STFail(@"Not implemented");
}

@end
