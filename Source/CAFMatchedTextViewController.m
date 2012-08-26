//
//  CAFMatchedTextViewController.m
//  Curiosity
//
//  Created by Matthew Thomas on 8/26/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import "CAFMatchedTextViewController.h"

static void *CAFMatchedTextViewControllerContext = &CAFMatchedTextViewControllerContext;

@interface CAFMatchedTextViewController ()
@property (strong, nonatomic) IBOutlet UITextView *matchedTextView;
@end

@implementation CAFMatchedTextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self addObserver:self
               forKeyPath:@"regexString"
                  options:NSKeyValueObservingOptionNew
                  context:CAFMatchedTextViewControllerContext];
    }
    return self;
}


- (void)dealloc
{
    [self removeObserver:self
              forKeyPath:@"regexString"
                 context:CAFMatchedTextViewControllerContext];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateRegexMatch];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - KeyValueObserving
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == CAFMatchedTextViewControllerContext) {
        [self updateRegexMatch];
    } else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}


#pragma mark - Private Instance Methods
- (void)updateRegexMatch
{
    NSError *regexError;
    NSLog(@"self.regexString: %@", self.regexString);
    if (!self.regexString) {
        return;
    }
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.regexString
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&regexError];
    if (!regex) {
        if (regexError) {
            NSLog(@"regexError: %@", regexError);
        }
    }
    
    NSLog(@"self.inputText: %@", self.inputText);
    NSRange inputTextRange = NSMakeRange(0, [self.inputText length]);
    
    NSUInteger matchCount = [regex numberOfMatchesInString:self.inputText
                                                   options:0
                                                     range:inputTextRange];
    NSLog(@"matchCount: %d", matchCount);
    
    NSRange noRange = NSMakeRange(NSNotFound, 0);
    
    NSRange firstMatchRange = [regex rangeOfFirstMatchInString:self.inputText
                                                       options:0
                                                         range:inputTextRange];
    if (NSEqualRanges(firstMatchRange, noRange)) {
        NSLog(@"No match found");
    } else {
        NSLog(@"Range of first match: %@", NSStringFromRange(firstMatchRange));
    }
    
    NSArray *matches = [regex matchesInString:self.inputText
                                      options:0
                                        range:inputTextRange];
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
    
    NSMutableAttributedString *displayString = [[NSMutableAttributedString alloc] initWithString:self.inputText];
    [regex enumerateMatchesInString:self.inputText
                            options:0
                              range:inputTextRange
                         usingBlock:^(NSTextCheckingResult *result,
                                      NSMatchingFlags flags,
                                      BOOL *stop) {
                             [displayString addAttribute:NSBackgroundColorAttributeName
                                                   value:[UIColor redColor]
                                                   range:result.range];
                         }];
    self.matchedTextView.attributedText = displayString;
}

@end
