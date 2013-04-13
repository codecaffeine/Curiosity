//
//  CAFMatchedTextViewModel.m
//  Curiosity
//
//  Created by Matthew Thomas on 4/9/13.
//  Copyright (c) 2013 Matthew Thomas. All rights reserved.
//

#import "CAFMatchedTextViewModel.h"

@implementation CAFMatchedTextViewModel

- (RACSignal *)matches
{
    return [RACSignal
            combineLatest:@[RACAble(self.sourceText), RACAble(self.regex)]
            reduce:^(NSString *sourceText, NSRegularExpression *regex) {
                return [regex matchesInString:sourceText
                                      options:0
                                        range:NSMakeRange(0, sourceText.length)];
            }];
}

@end
