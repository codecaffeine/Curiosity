//
//  CAFGitHubUser.m
//  CAFGitHub
//
//  Created by Matthew Thomas on 12/26/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import "CAFGitHubUser.h"

@implementation CAFGitHubUser

+ (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

+ (NSDictionary *)externalRepresentationKeyPathsByPropertyKey
{
    return [super.externalRepresentationKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
                @"gitHubID": @"id",
                @"username": @"login",
                @"avatarURL": @"avatar_url",
                @"gravatarID": @"gravatar_id",
                @"url": @"url",
                @"name": @"name",
                @"company": @"company",
                @"blogURL": @"blog",
                @"location": @"location",
                @"email": @"email",
                @"hireable": @"hireable",
                @"bio": @"bio",
                @"publicRepoCount": @"public_repos",
                @"publicGistCount": @"public_gists",
                @"followersCount": @"followers",
                @"followingCount": @"following",
                @"htmlURL": @"html_url",
                @"dateCreated": @"created_at",
                @"type": @"type",
                @"totalPrivateRepoCount": @"total_private_repos",
                @"ownedPrivateRepoCount": @"owned_private_repos",
                @"privateGistCount": @"private_gists",
                @"diskUsage": @"disk_usage",
                @"collaboratorCount": @"collaborators"
            }];
}


+ (NSValueTransformer *)avatarURLTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


+ (NSValueTransformer *)urlTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


+ (NSValueTransformer *)blogURLTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


+ (NSValueTransformer *)htmlURLTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


+ (NSValueTransformer *)dateCreatedTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}


@end
