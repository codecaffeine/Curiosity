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
    RAC(self.matchedTextView.alpha) = [RACAbleWithStart(self.viewModel.sourceText) map:^id(NSString *sourceText) {
        return @(sourceText == nil ? 0.0f : 1.0f);
    }];
    RAC(self.matchedTextView.text) = [RACAbleWithStart(self.viewModel.sourceText) map:^id(NSString *sourceText) {
        return sourceText;
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
        self.viewModel.sourceText = fileURLViewController.fileContents;
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
