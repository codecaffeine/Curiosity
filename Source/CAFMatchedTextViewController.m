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

    RAC(self.matchedTextView.attributedText) = [RACAble(self.viewModel.text) map:^id(NSString *text) {
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:@"SourceCodePro-Regular" size:14.0]};
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text
                                                                               attributes:attributes];
        return attributedString;
    }];
    
    [self.viewModel.regexMatchesSignal subscribeNext:^(NSArray *matches) {
        NSDictionary *attributes = @{
            NSFontAttributeName : [UIFont fontWithName:@"SourceCodePro-Semibold" size:14.0],
            NSBackgroundColorAttributeName : [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.2]
        };
        NSMutableAttributedString *displayString = [self.matchedTextView.attributedText mutableCopy];
        for (NSTextCheckingResult *result in matches) {
            [displayString addAttributes:attributes range:result.range];
        }
        self.matchedTextView.attributedText = displayString;
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
//    self.viewModel.regex = [NSRegularExpression regularExpressionWithPattern:@"\\w" options:0 error:&regexError];
    
    
//    if (self.inputText) {
//        NSRange inputTextRange = NSMakeRange(0, [self.inputText length]);
//        NSMutableAttributedString *displayString = [[NSMutableAttributedString alloc] initWithString:self.inputText];
//        [displayString addAttribute:NSFontAttributeName
//                              value:[UIFont fontWithName:@"SourceCodePro-Regular"
//                                                    size:14.0]
//                              range:inputTextRange];
//        [regex enumerateMatchesInString:self.inputText
//                                options:0
//                                  range:inputTextRange
//                             usingBlock:^(NSTextCheckingResult *result,
//                                          NSMatchingFlags flags,
//                                          BOOL *stop) {
//                                 NSDictionary *attributes = @{
//                                                              NSFontAttributeName : [UIFont fontWithName:@"SourceCodePro-Semibold"
//                                                                                                    size:14.0],
//                                                              NSBackgroundColorAttributeName : [UIColor colorWithRed:0.0
//                                                                                                               green:1.0
//                                                                                                                blue:0.0
//                                                                                                               alpha:0.2]
//                                                              };
//                                 [displayString addAttributes:attributes
//                                                        range:result.range];
//                             }];
//        self.matchedTextView.attributedText = displayString;
//    }
}

@end
