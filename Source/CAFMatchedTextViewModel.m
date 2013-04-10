//
//  CAFMatchedTextViewModel.m
//  Curiosity
//
//  Created by Matthew Thomas on 4/9/13.
//  Copyright (c) 2013 Matthew Thomas. All rights reserved.
//

#import "CAFMatchedTextViewModel.h"
#import <EXTScope.h>

@implementation CAFMatchedTextViewModel

- (RACSignal *)regexMatchesSignal {
    return [RACSignal
            combineLatest:@[RACAble(self.text), RACAble(self.regex)]
            reduce:^id(NSString *string, NSRegularExpression *regex){
                return [regex matchesInString:string
                                      options:0
                                        range:NSMakeRange(0, string.length)];
            }];
}

@end
