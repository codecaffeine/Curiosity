//
//  CAFMockURLConnection.h
//  Curiosity
//
//  Created by Matthew Thomas on 3/31/13.
//  Copyright (c) 2013 Matthew Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `CAFMockURLConnection` is a `NSURLProtocol` subclass that mocks responses used
 by the NSURL loading system for testing purposes. This is based off of 
 information and code from:
 
 - http://nshipster.com/nsurlprotocol/
 - http://www.infinite-loop.dk/blog/2011/09/using-nsurlprotocol-for-injecting-test-data/
 */

@interface CAFMockURLConnection : NSURLProtocol

/**
 Sets the statusCode, headerFields, and bodyData we will send back to the client
 
 @param statusCode   The HTTP status code to send back
 @param headerFields The HTTP header fields to send back
 @param bodyData     The HTTP body data to send back
 */
+ (void)setResponseWithStatusCode:(NSInteger)statusCode
                     headerFields:(NSDictionary *)headerFields
                         bodyData:(NSData *)bodyData;


/**
 Sets the error to return to the client
 
 @param error The error to return to the client
 */
+ (void)setError:(NSError *)error;

@end
