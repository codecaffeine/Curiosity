//
//  CAFGitHubUser.h
//  CAFGitHub
//
//  Created by Matthew Thomas on 12/26/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CAFGitHubUser : MTLModel
@property (assign, nonatomic, readonly) NSUInteger gitHubID;
@property (copy, nonatomic, readonly) NSString *username;
@property (copy, nonatomic, readonly) NSURL *avatarURL;
@property (copy, nonatomic, readonly) NSString *gravatarID;
@property (copy, nonatomic, readonly) NSURL *url;
@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *company;
@property (copy, nonatomic, readonly) NSURL *blogURL;
@property (copy, nonatomic, readonly) NSString *location;
@property (copy, nonatomic, readonly) NSString *email;
@property (assign, nonatomic, readonly) BOOL hireable;
@property (copy, nonatomic, readonly) NSString *bio;
@property (assign, nonatomic, readonly) NSUInteger publicRepoCount;
@property (assign, nonatomic, readonly) NSUInteger publicGistCount;
@property (assign, nonatomic, readonly) NSUInteger followersCount;
@property (assign, nonatomic, readonly) NSUInteger followingCount;
@property (copy, nonatomic, readonly) NSURL *htmlURL;
@property (copy, nonatomic, readonly) NSDate *dateCreated;
@property (copy, nonatomic, readonly) NSString *type;
@property (assign, nonatomic, readonly) NSUInteger totalPrivateRepoCount;
@property (assign, nonatomic, readonly) NSUInteger ownedPrivateRepoCount;
@property (assign, nonatomic, readonly) NSUInteger privateGistCount;
@property (assign, nonatomic, readonly) NSUInteger diskUsage;
@property (assign, nonatomic, readonly) NSUInteger collaboratorCount;
@end
