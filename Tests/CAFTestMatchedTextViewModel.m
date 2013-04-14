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
    NSUInteger sanityCount = [viewModel.regex numberOfMatchesInString:viewModel.sourceText
                                                              options:0
                                                                range:NSMakeRange(0, viewModel.sourceText.length)];
    STAssertTrue(sanityCount > 0, @"regex should have matches but has %u", sanityCount);

    NSDate *until = [NSDate dateWithTimeIntervalSinceNow:0.5];
    while (!signalCalled && ([until compare:[NSDate date]] == NSOrderedDescending)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:until];
    }
    STAssertTrue(signalCalled, @"signal should have been called");
}


- (void)testSettingSourceTextAndRegexBeforeSignalCreationSendSignal {
    CAFMatchedTextViewModel *viewModel = [CAFMatchedTextViewModel new];
    
    viewModel.sourceText = @"a url = http://codecaffene.com right?";
    viewModel.regex = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink
                                                      error:nil];
    NSUInteger sanityCount = [viewModel.regex numberOfMatchesInString:viewModel.sourceText
                                                              options:0
                                                                range:NSMakeRange(0, viewModel.sourceText.length)];
    STAssertTrue(sanityCount > 0, @"regex should have matches but has %u", sanityCount);
    
    __block BOOL signalCalled = NO;
    [viewModel.matches subscribeNext:^(NSArray *matches) {
        signalCalled = YES;
	}];
    NSDate *until = [NSDate dateWithTimeIntervalSinceNow:0.5];
    while (!signalCalled && ([until compare:[NSDate date]] == NSOrderedDescending)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:until];
    }
    STAssertTrue(signalCalled, @"signal should have been called");
}


@end
