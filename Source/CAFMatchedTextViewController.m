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
- (IBAction)urlFieldDidEndOnExit:(UITextField *)sender;
@end

@implementation CAFMatchedTextViewController

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


- (void)setRegexString:(NSString *)regexString
{
    _regexString = [regexString copy];
    [self updateRegexMatch];
}


- (void)setInputText:(NSString *)inputText
{
    _inputText = [inputText copy];
}


- (IBAction)urlFieldDidEndOnExit:(UITextField *)sender {
    NSLog(@"urlFieldDidEndOnExit: %@", sender.text);
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
    
    if (!regex &&regexError ) {
        NSLog(@"regexError: %@", regexError);
    }
    
    NSRange inputTextRange = NSMakeRange(0, [self.inputText length]);
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
    self.matchedTextView.text = nil;
    self.matchedTextView.attributedText = displayString;
}

@end
