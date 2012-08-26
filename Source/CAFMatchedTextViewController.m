//
//  CAFMatchedTextViewController.m
//  Curiosity
//
//  Created by Matthew Thomas on 8/26/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import "CAFMatchedTextViewController.h"

@interface CAFMatchedTextViewController ()
@property (strong, nonatomic) IBOutlet UITextView *matchedTextView;
@end

@implementation CAFMatchedTextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSError *regexError;
    NSString *regexPattern = @"m.tt";
    NSLog(@"regexPattern: %@", regexPattern);
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&regexError];
    if (!regex) {
        NSLog(@"regexError: %@", regexError);
    }
    
    NSString *matchingString = @"and the little mutt asked \"What is a matter?\"";
    NSLog(@"matchString: %@", matchingString);
    NSRange matchingStringRange = NSMakeRange(0, [matchingString length]);
    
    NSUInteger matchCount = [regex numberOfMatchesInString:matchingString
                                                   options:0
                                                     range:matchingStringRange];
    NSLog(@"matchCount: %d", matchCount);
    
    NSRange noRange = NSMakeRange(NSNotFound, 0);
    
    NSRange firstMatchRange = [regex rangeOfFirstMatchInString:matchingString
                                                       options:0
                                                         range:matchingStringRange];
    if (NSEqualRanges(firstMatchRange, noRange)) {
        NSLog(@"No match found");
    } else {
        NSLog(@"Range of first match: %@", NSStringFromRange(firstMatchRange));
    }
    
    NSArray *matches = [regex matchesInString:matchingString
                                      options:0
                                        range:matchingStringRange];
    for (NSTextCheckingResult *result in matches) {
        NSLog(@"result: %@", result);
        NSLog(@"result.range: %@", NSStringFromRange(result.range));
        NSLog(@"result.numberOfRanges: %d", result.numberOfRanges);
        NSLog(@"result.components: %@", result.components);
        if (result.resultType == NSTextCheckingTypeOrthography) {
            NSLog(@"resultType: %@", @"NSTextCheckingTypeOrthography");
        } else if (result.resultType == NSTextCheckingTypeSpelling) {
            NSLog(@"resultType: %@", @"NSTextCheckingTypeSpelling");
        } else if (result.resultType == NSTextCheckingTypeGrammar) {
            NSLog(@"resultType: %@", @"NSTextCheckingTypeGrammar");
        } else if (result.resultType == NSTextCheckingTypeDate) {
            NSLog(@"resultType: %@", @"NSTextCheckingTypeDate");
        } else if (result.resultType == NSTextCheckingTypeAddress) {
            NSLog(@"resultType: %@", @"NSTextCheckingTypeAddress");
        } else if (result.resultType == NSTextCheckingTypeLink) {
            NSLog(@"resultType: %@", @"NSTextCheckingTypeLink");
        } else if (result.resultType == NSTextCheckingTypeQuote) {
            NSLog(@"resultType: %@", @"NSTextCheckingTypeQuote");
        } else if (result.resultType == NSTextCheckingTypeDash) {
            NSLog(@"resultType: %@", @"NSTextCheckingTypeDash");
        } else if (result.resultType == NSTextCheckingTypeReplacement) {
            NSLog(@"resultType: %@", @"NSTextCheckingTypeReplacement");
        } else if (result.resultType == NSTextCheckingTypeCorrection) {
            NSLog(@"resultType: %@", @"NSTextCheckingTypeCorrection");
        } else if (result.resultType == NSTextCheckingTypeRegularExpression) {
            NSLog(@"resultType: %@", @"NSTextCheckingTypeRegularExpression");
        } else if (result.resultType == NSTextCheckingTypePhoneNumber) {
            NSLog(@"resultType: %@", @"NSTextCheckingTypePhoneNumber");
        } else if (result.resultType == NSTextCheckingTypeTransitInformation) {
            NSLog(@"resultType: %@", @"NSTextCheckingTypeTransitInformation");
        }
    }
    
    NSMutableAttributedString *displayString = [[NSMutableAttributedString alloc] initWithString:matchingString];
    [regex enumerateMatchesInString:matchingString
                            options:0
                              range:matchingStringRange
                         usingBlock:^(NSTextCheckingResult *result,
                                      NSMatchingFlags flags,
                                      BOOL *stop) {
                             [displayString addAttribute:NSBackgroundColorAttributeName
                                                   value:[UIColor redColor]
                                                   range:result.range];
                         }];
    self.matchedTextView.attributedText = displayString;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
