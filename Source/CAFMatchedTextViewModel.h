//
//  CAFMatchedTextViewModel.h
//  Curiosity
//
//  Created by Matthew Thomas on 4/9/13.
//  Copyright (c) 2013 Matthew Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CAFMatchedTextViewModel : NSObject
@property (copy, nonatomic) NSMutableString *text;
@property (copy, nonatomic) NSRegularExpression *regex;
- (RACSignal *)regexMatchesSignal;
@end
