//
//  CAFMatchedTextViewController.m
//  Curiosity
//
//  Created by Matthew Thomas on 8/26/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import "CAFMatchedTextViewController.h"
#import "CAFFileFromURLViewController.h"
#import "CAFMatchedTextViewModel.h"
#import <QuartzCore/QuartzCore.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <EXTScope.h>

@interface CAFMatchedTextViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextView *matchedTextView;
@property (strong, nonatomic) IBOutlet UIButton *matchURLsButton;
@property (strong, nonatomic) CAFMatchedTextViewModel *viewModel;
@end

@implementation CAFMatchedTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [CAFMatchedTextViewModel new];

    RAC(self.matchedTextView.attributedText) = [RACSignal
        combineLatest:@[RACAbleWithStart(self.viewModel.text), RACAbleWithStart(self.viewModel.regex)] reduce:^(NSString *text, NSRegularExpression *regex) {
            NSMutableAttributedString *displayString = nil;
            if (text) {
                NSDictionary *baseAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"SourceCodePro-Regular" size:14.0]};
                displayString = [[NSMutableAttributedString alloc] initWithString:text attributes:baseAttributes];

                NSDictionary *matchAttributes = @{
                    NSFontAttributeName : [UIFont fontWithName:@"SourceCodePro-Semibold" size:14.0],
                    NSBackgroundColorAttributeName : [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.2]
                };
                NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
                for (NSTextCheckingResult *result in matches) {
                    [displayString addAttributes:matchAttributes range:result.range];
                }
            }
            return displayString;
    }];
};


#pragma mark - Storyboard Unwinding
- (IBAction)cancelledImportingFile:(UIStoryboardSegue *)segue
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)doneImportingFile:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[CAFFileFromURLViewController class]]) {
        CAFFileFromURLViewController *fileURLViewController = (CAFFileFromURLViewController *)segue.sourceViewController;
        self.title = fileURLViewController.filename;
        self.viewModel.text = [fileURLViewController.fileContents mutableCopy];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Private Instance Methods
- (IBAction)matchURLsButtonPressed:(UIButton *)sender {
    NSError *regexError;
    self.viewModel.regex = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink
                                                           error:&regexError];
}

@end
