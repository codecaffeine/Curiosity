//
//  CAFRegexInputViewController.m
//  Curiosity
//
//  Created by Matthew Thomas on 8/26/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import "CAFRegexInputViewController.h"


@interface CAFRegexInputViewController () <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *regexTextView;
@end


@implementation CAFRegexInputViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.regexTextView becomeFirstResponder];
    [self.delegate regexInputViewController:self
                     regexTextViewDidChange:self.regexTextView];
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    [self.delegate regexInputViewController:self
                     regexTextViewDidChange:textView];
}

@end
