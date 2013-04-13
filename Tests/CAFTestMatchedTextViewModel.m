//
//  CAFTestMatchedTextViewModel.m
//  Curiosity
//
//  Created by Matthew Thomas on 4/13/13.
//  Copyright (c) 2013 Matthew Thomas. All rights reserved.
//

#import "CAFTestMatchedTextViewModel.h"
#import "CAFMatchedTextViewModel.h"

@implementation CAFTestMatchedTextViewModel

- (void)testSettingSourceTextAndRegexSendSignal {
    CAFMatchedTextViewModel *viewModel = [CAFMatchedTextViewModel new];
    __block BOOL signalCalled = NO;
    [viewModel.matches subscribeNext:^(NSArray *matches) {
        signalCalled = YES;
	}];
    
    viewModel.sourceText = @"a url = http://codecaffene.com right?";
    viewModel.regex = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink
                                                      error:nil];
    STAssertNotNil(viewModel.regex, @"Why is the regex nil?");

    // Run loop
    NSDate *until = [NSDate dateWithTimeIntervalSinceNow:0.5];
    while (!signalCalled && ([until compare:[NSDate date]] == NSOrderedDescending)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:until];
    }
    STAssertTrue(signalCalled, @"signal should have been called");
}

@end
