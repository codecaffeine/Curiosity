//
//  CAFCanvasViewController.m
//  Curiosity
//
//  Created by Matthew Thomas on 4/14/13.
//  Copyright (c) 2013 Matthew Thomas. All rights reserved.
//

#import "CAFCanvasViewController.h"
#import "CAFMatchedTextViewModel.m"
#import <ReactiveCocoa/ReactiveCocoa.h>

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
    RAC(self.addSourceButton.hidden) = [RACAbleWithStart(self.viewModel.sourceText)
                                        map:^id(NSString *sourceText) {
                                            return @(sourceText != nil);
                                        }];
    RAC(self.textView.hidden) = [RACAbleWithStart(self.viewModel.sourceText)
                                        map:^id(NSString *sourceText) {
                                            return @(sourceText == nil);
                                        }];
    
    [[self.addSourceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"x: %@", NSStringFromClass([x class]));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
