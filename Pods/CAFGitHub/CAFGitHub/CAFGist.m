//
//  CAFGist.m
//  CAFGitHub
//
//  Created by Matthew Thomas on 12/11/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import "CAFGist.h"
#import "CAFGistFile.h"

@implementation CAFGist

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
            @"url": @"url",
            @"identifier": @"id",
            @"desc": @"description",
            @"isPublic": @"public",
            @"commentsCount": @"comments",
            @"commentsURL": @"comments_url",
            @"htmlURL": @"html_url",
            @"gitPullURL": @"git_pull_url",
            @"gitPushURL": @"git_push_url",
            @"dateCreated": @"created_at",
            @"files": @"files"
            }];
}


+ (NSValueTransformer *)urlTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


+ (NSValueTransformer *)commentsURLTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


+ (NSValueTransformer *)htmlURLTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


+ (NSValueTransformer *)gitPullURLTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


+ (NSValueTransformer *)gitPushURLTransformer
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


+ (NSValueTransformer *)filesTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *dictionary) {
        return [dictionary mtl_mapValuesUsingBlock:^id(id key, id value) {
            
            CAFGistFile *gistFile = nil;
            if ([value isKindOfClass:[NSDictionary class]]) {
                gistFile = [CAFGistFile modelWithExternalRepresentation:value];
            }
            
            return gistFile ? gistFile : [NSNull null];
        }];
        
    } reverseBlock:^(NSDictionary *dictionary) {
        return [dictionary mtl_mapValuesUsingBlock:^id(id key, id value) {
            
            NSDictionary *externalRepresentation = nil;
            if ([value isKindOfClass:[CAFGistFile class]]) {
                CAFGistFile *gistFile = (CAFGistFile *)value;
                externalRepresentation = [gistFile externalRepresentation];
            }
            
            return externalRepresentation ? externalRepresentation : [NSNull null];
        }];
    }];
}


@end
