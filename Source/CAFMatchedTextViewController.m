//
//  CAFMatchedTextViewController.m
//  Curiosity
//
//  Created by Matthew Thomas on 8/26/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import "CAFMatchedTextViewController.h"
#import "CAFFileFromURLViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CAFMatchedTextViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *regexTextField;
@property (strong, nonatomic) IBOutlet UIView *regexTextBar;
@property (strong, nonatomic) IBOutlet UITextView *matchedTextView;
@end

@implementation CAFMatchedTextViewController {
    UIView *_inputAccessoryPlaceholderView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.matchedTextView.font = [UIFont fontWithName:@"SourceCodePro-Regular" size:16.0];
    NSNotificationCenter *defaultNotificationCenter = [NSNotificationCenter defaultCenter];
    [defaultNotificationCenter addObserverForName:UIKeyboardWillChangeFrameNotification
                                           object:nil
                                            queue:[NSOperationQueue mainQueue]
                                       usingBlock:^(NSNotification *notification) {
                                           // Save screenshot of regexField
                                           UIGraphicsBeginImageContext(self.regexTextBar.frame.size);
                                           [[self.regexTextBar layer] renderInContext:UIGraphicsGetCurrentContext()];
                                           UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
                                           UIGraphicsEndImageContext();
                                           
                                           for (UIView *subviews in _inputAccessoryPlaceholderView.subviews) {
                                               if ([subviews isKindOfClass:[UIImageView class]]) {
                                                   [subviews removeFromSuperview];
                                                   break;
                                               }
                                           }
                                           
                                           UIImageView *imageView = [[UIImageView alloc] initWithImage:screenshot];
                                           [_inputAccessoryPlaceholderView addSubview:imageView];
                                           imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                                           CGRect imageFrame = imageView.frame;
                                           imageFrame.origin.x = _inputAccessoryPlaceholderView.bounds.size.width - imageFrame.size.width;
                                           imageView.frame = imageFrame;
                                           
                                           self.regexTextBar.hidden = YES;
                                           _inputAccessoryPlaceholderView.hidden = NO;
                                       }];
    
    [defaultNotificationCenter addObserverForName:UIKeyboardDidChangeFrameNotification
                                           object:nil
                                            queue:[NSOperationQueue mainQueue]
                                       usingBlock:^(NSNotification *notification) {
                                           _inputAccessoryPlaceholderView.hidden = YES;
                                           self.regexTextBar.hidden = NO;
                                           NSValue *endKeyboardFrame = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
                                           CGRect endKeyboardRect = [endKeyboardFrame CGRectValue];
                                           CGRect endKeyboardRectForView = [self.view convertRect:endKeyboardRect
                                                                                         fromView:nil];
                                           CGRect regexTextBarFrame = self.regexTextBar.frame;
                                           CGFloat maxY = self.view.bounds.size.height - regexTextBarFrame.size.height;
                                           regexTextBarFrame.origin.y = MIN(endKeyboardRectForView.origin.y, maxY);
                                           self.regexTextBar.frame = regexTextBarFrame;
                                      }];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_inputAccessoryPlaceholderView) {
        _inputAccessoryPlaceholderView = [[UIView alloc] initWithFrame:self.regexTextBar.frame];
        _inputAccessoryPlaceholderView.backgroundColor = [UIColor clearColor];
        _inputAccessoryPlaceholderView.hidden = YES;
        
        CGRect bottomBarFrame = _inputAccessoryPlaceholderView.bounds;
        bottomBarFrame.size.height = 1.0;
        bottomBarFrame.origin.y = _inputAccessoryPlaceholderView.bounds.size.height - bottomBarFrame.size.height;
        UIView *bottomBlack = [[UIView alloc] initWithFrame:bottomBarFrame];
        bottomBlack.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        bottomBlack.backgroundColor = [UIColor blackColor];
        [_inputAccessoryPlaceholderView addSubview:bottomBlack];
    }
    self.regexTextField.inputAccessoryView = _inputAccessoryPlaceholderView;
    
    [self updateRegexMatch];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setRegexString:(NSString *)regexString
{
    _regexString = [regexString copy];
    [self updateRegexMatch];
}


- (void)setInputText:(NSString *)inputText
{
    _inputText = [inputText copy];
    [self updateRegexMatch];
}


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
        self.matchedTextView.text = fileURLViewController.fileContents;
        self.inputText = self.matchedTextView.text;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Private Instance Methods
- (void)updateRegexMatch
{
    NSError *regexError;    
    NSRegularExpression *regex;
    if (self.regexString) {
        regex = [NSRegularExpression regularExpressionWithPattern:self.regexString
                                                          options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                                            error:&regexError];
    }
    
    if (self.inputText) {
        NSRange inputTextRange = NSMakeRange(0, [self.inputText length]);
        NSMutableAttributedString *displayString = [[NSMutableAttributedString alloc] initWithString:self.inputText];
        [displayString addAttribute:NSFontAttributeName
                              value:[UIFont fontWithName:@"SourceCodePro-Regular"
                                                    size:14.0]
                              range:inputTextRange];
        [regex enumerateMatchesInString:self.inputText
                                options:0
                                  range:inputTextRange
                             usingBlock:^(NSTextCheckingResult *result,
                                          NSMatchingFlags flags,
                                          BOOL *stop) {
                                 NSDictionary *attributes = @{
                                     NSFontAttributeName : [UIFont fontWithName:@"SourceCodePro-Semibold"
                                                                           size:14.0],
                                     NSBackgroundColorAttributeName : [UIColor colorWithRed:0.0
                                                                                      green:1.0
                                                                                       blue:0.0
                                                                                      alpha:0.2]
                                 };
                                 [displayString addAttributes:attributes
                                                        range:result.range];
                             }];
        self.matchedTextView.text = nil;
        self.matchedTextView.attributedText = displayString;
    }
}


- (IBAction)matchURLsButtonPressed:(UIButton *)sender {
    NSError *regexError;
    NSRegularExpression *regex = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink
                                                                 error:&regexError];
    
    if (self.inputText) {
        NSRange inputTextRange = NSMakeRange(0, [self.inputText length]);
        NSMutableAttributedString *displayString = [[NSMutableAttributedString alloc] initWithString:self.inputText];
        [displayString addAttribute:NSFontAttributeName
                              value:[UIFont fontWithName:@"SourceCodePro-Regular"
                                                    size:14.0]
                              range:inputTextRange];
        [regex enumerateMatchesInString:self.inputText
                                options:0
                                  range:inputTextRange
                             usingBlock:^(NSTextCheckingResult *result,
                                          NSMatchingFlags flags,
                                          BOOL *stop) {
                                 NSDictionary *attributes = @{
                                                              NSFontAttributeName : [UIFont fontWithName:@"SourceCodePro-Semibold"
                                                                                                    size:14.0],
                                                              NSBackgroundColorAttributeName : [UIColor colorWithRed:0.0
                                                                                                               green:1.0
                                                                                                                blue:0.0
                                                                                                               alpha:0.2]
                                                              };
                                 [displayString addAttributes:attributes
                                                        range:result.range];
                             }];
        self.matchedTextView.text = nil;
        self.matchedTextView.attributedText = displayString;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.regexString = [textField.text stringByReplacingCharactersInRange:range
                                                               withString:string];
    return YES;
}

@end
