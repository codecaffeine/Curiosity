//
//  CAFDetailViewController.m
//  Curiosity
//
//  Created by Matthew Thomas on 8/25/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import "CAFDetailViewController.h"


@interface CAFDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end


@implementation CAFDetailViewController

#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
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
    self.detailDescriptionLabel.attributedText = displayString;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Property Accessors
- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}


#pragma mark - Private Methods
- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        id timeStampValue = [self.detailItem valueForKey:@"timeStamp"];
        self.detailDescriptionLabel.text = [timeStampValue description];
    }
}


#pragma mark - UISplitViewControllerDelegate
- (void)splitViewController:(UISplitViewController *)splitController
     willHideViewController:(UIViewController *)viewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}


- (void)splitViewController:(UISplitViewController *)splitController
     willShowViewController:(UIViewController *)viewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the
    // button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
