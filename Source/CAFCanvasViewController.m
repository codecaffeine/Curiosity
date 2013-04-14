//
//  CAFCanvasViewController.m
//  Curiosity
//
//  Created by Matthew Thomas on 4/14/13.
//  Copyright (c) 2013 Matthew Thomas. All rights reserved.
//

#import "CAFCanvasViewController.h"
#import "CAFMatchedTextViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <EXTScope.h>

@interface CAFCanvasViewController ()
@property (strong, nonatomic) CAFMatchedTextViewModel *viewModel;
@property (strong, nonatomic) IBOutlet UIButton *addSourceButton;
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
        self.viewModel.sourceText = @"A Man A Plan A Canal Panama";
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
