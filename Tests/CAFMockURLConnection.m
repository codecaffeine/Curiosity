//
//  CAFMockURLConnection.m
//  Curiosity
//
//  Created by Matthew Thomas on 3/31/13.
//  Copyright (c) 2013 Matthew Thomas. All rights reserved.
//

#import "CAFMockURLConnection.h"

NSData *CAFMockURLConnectionResponseData;
NSDictionary *CAFMockURLConnectionHeaderFields;
NSInteger CAFMockURLConnectionStatusCode;
NSError *CAFMockURLConnectionError;

@implementation CAFMockURLConnection

#pragma mark - NSURLProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return YES;
}


+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}


- (void)startLoading {
    NSURLRequest *request = [self request];
    id<NSURLProtocolClient> client = [self client];
    
    if (CAFMockURLConnectionError) {
        [client URLProtocol:self didFailWithError:CAFMockURLConnectionError];
        return;
    }
    
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[request URL]
                                                              statusCode:CAFMockURLConnectionStatusCode
                                                             HTTPVersion:@"HTTP/1.1"
                                                            headerFields:CAFMockURLConnectionHeaderFields];
    [client URLProtocol:self
     didReceiveResponse:response
     cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [client URLProtocol:self
            didLoadData:CAFMockURLConnectionResponseData];
    [client URLProtocolDidFinishLoading:self];
}


- (void)stopLoading {}


#pragma mark - Instance Methods
+ (void)setResponseWithStatusCode:(NSInteger)statusCode
                     headerFields:(NSDictionary *)headerFields
                         bodyData:(NSData *)bodyData {
    CAFMockURLConnectionStatusCode = statusCode;
    CAFMockURLConnectionHeaderFields = [headerFields copy];
    CAFMockURLConnectionResponseData = [bodyData copy];
}


+ (void)setError:(NSError *)error {
    CAFMockURLConnectionError = [error copy];
}

@end
