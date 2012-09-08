//
//  CAFMatchedTextViewController.m
//  Curiosity
//
//  Created by Matthew Thomas on 8/26/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import "CAFMatchedTextViewController.h"

@interface CAFMatchedTextViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *regexTextField;
@property (strong, nonatomic) IBOutlet UIView *regexTextBar;
@property (strong, nonatomic) IBOutlet UITextView *matchedTextView;
- (IBAction)urlFieldDidEndOnExit:(UITextField *)sender;
@end

@implementation CAFMatchedTextViewController {
    UIView *_awesomeView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _awesomeView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    _awesomeView.backgroundColor = [UIColor purpleColor];
    _awesomeView.hidden = YES;
    self.regexTextField.inputAccessoryView = _awesomeView;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"self.view.bounds: %@", NSStringFromCGRect(self.view.bounds));
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *notification) {
                                                      self.regexTextBar.hidden = YES;
                                                      _awesomeView.hidden = NO;
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidChangeFrameNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *notification) {
                                                      _awesomeView.hidden = YES;
                                                      self.regexTextBar.hidden = NO;
                                                      NSValue *endKeyboardFrame = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
                                                      CGRect endKeyboardRect = [endKeyboardFrame CGRectValue];
                                                      CGRect endKeyboardRectForView = [self.view convertRect:endKeyboardRect
                                                                                                    fromView:nil];
                                                      CGRect regexTextBarFrame = self.regexTextBar.frame;
                                                      CGFloat maxY = self.view.bounds.size.height - regexTextBarFrame.size.height;
                                                      NSLog(@"maxY: %f", maxY);
                                                      regexTextBarFrame.origin.y = MIN(endKeyboardRectForView.origin.y, maxY);
                                                      self.regexTextBar.frame = regexTextBarFrame;
                                                  }];
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


- (IBAction)urlFieldDidEndOnExit:(UITextField *)urlField
{
    NSLog(@"urlFieldDidEndOnExit: %@", urlField);
    NSURL *url = [NSURL URLWithString:urlField.text];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               NSLog(@"response.textEncodingName: %@", response.textEncodingName);
                               NSString *textEncodingName = response.textEncodingName;
                               if (textEncodingName) {
                                   CFStringEncoding stringEncoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)textEncodingName);
                                   NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(stringEncoding);
                                   NSString *responseString = [[NSString alloc] initWithData:data
                                                                                    encoding:encoding];
                                   self.inputText = responseString;
                                   self.title = response.suggestedFilename;
                               }
                           }];
}


#pragma mark - Private Instance Methods
- (void)updateRegexMatch
{
    NSError *regexError;    
    NSRegularExpression *regex;
    if (self.regexString) {
        regex = [NSRegularExpression regularExpressionWithPattern:self.regexString
                                                          options:NSRegularExpressionCaseInsensitive
                                                            error:&regexError];
    }
    
    if (self.inputText) {
        NSRange inputTextRange = NSMakeRange(0, [self.inputText length]);
        NSMutableAttributedString *displayString = [[NSMutableAttributedString alloc] initWithString:self.inputText];
        [displayString addAttribute:NSForegroundColorAttributeName
                              value:[UIColor grayColor]
                              range:inputTextRange];
        [regex enumerateMatchesInString:self.inputText
                                options:0
                                  range:inputTextRange
                             usingBlock:^(NSTextCheckingResult *result,
                                          NSMatchingFlags flags,
                                          BOOL *stop) {
                                 NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor blackColor], NSBackgroundColorAttributeName : [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.2]};
                                 [displayString addAttributes:attributes
                                                        range:result.range];
                             }];
        self.matchedTextView.text = nil;
        self.matchedTextView.attributedText = displayString;
    }
}

@end
