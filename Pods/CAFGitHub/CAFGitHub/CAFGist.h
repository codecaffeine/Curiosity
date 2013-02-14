//
//  CAFGist.h
//  CAFGitHub
//
//  Created by Matthew Thomas on 12/11/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CAFGist : MTLModel
@property (copy, nonatomic, readonly) NSURL *url;
@property (copy, nonatomic, readonly) NSString *identifier;
@property (copy, nonatomic, readonly) NSString *desc;
@property (assign, nonatomic, readonly) BOOL isPublic;
@property (assign, nonatomic, readonly) NSUInteger commentsCount;
@property (copy, nonatomic, readonly) NSURL *commentsURL;
@property (copy, nonatomic, readonly) NSURL *htmlURL;
@property (copy, nonatomic, readonly) NSURL *gitPullURL;
@property (copy, nonatomic, readonly) NSURL *gitPushURL;
@property (copy, nonatomic, readonly) NSDate *dateCreated;
@property (copy, nonatomic, readonly) NSDictionary *files;
@end
