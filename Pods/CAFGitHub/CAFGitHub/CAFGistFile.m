//
//  CAFGistFile.m
//  CAFGitHub
//
//  Created by Matthew Thomas on 12/22/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import "CAFGistFile.h"

@implementation CAFGistFile

+ (NSDictionary *)externalRepresentationKeyPathsByPropertyKey
{
    return [super.externalRepresentationKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
            @"name": @"filename",
            @"rawURL": @"raw_url",
            @"size": @"size"
            }];
}

+ (NSValueTransformer *)rawURLTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
