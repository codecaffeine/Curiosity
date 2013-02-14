//
//  CAFGistFile.h
//  CAFGitHub
//
//  Created by Matthew Thomas on 12/22/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CAFGistFile : MTLModel
@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSURL *rawURL;
@property (assign, nonatomic, readonly) NSUInteger size;
@end
