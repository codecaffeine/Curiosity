//
//  CAFCanvasViewController.m
//  Curiosity
//
//  Created by Matthew Thomas on 4/14/13.
//  Copyright (c) 2013 Matthew Thomas. All rights reserved.
//

#import "CAFCanvasViewController.h"
#import <EXTScope.h>

@interface CAFCanvasViewController ()
@property (strong, nonatomic) CAFMatchedTextViewModel *viewModel;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@end


@implementation CAFCanvasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.viewModel = [CAFMatchedTextViewModel new];
    @weakify(self);
    [RACAbleWithStart(self.viewModel.sourceText) subscribeNext:^(NSString *sourceText) {
        @strongify(self);
        self.textView.text = sourceText;
        
        @weakify(self);
        [UIView animateWithDuration:0.3 animations:^{
            @strongify(self);
            self.addSourceButton.alpha = (sourceText == nil) ? 1.0f : 0.0f;
            self.textView.alpha = (sourceText == nil) ? 0.0f : 1.0f;
        }];
    }];
    
    [[self.addSourceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
        NSLog(@"button: %@", button);
    }];
}

@end
