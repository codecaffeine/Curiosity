//
//  CAFCanvasViewController.h
//  Curiosity
//
//  Created by Matthew Thomas on 4/14/13.
//  Copyright (c) 2013 Matthew Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "CAFMatchedTextViewModel.h"

@interface CAFCanvasViewController : UIViewController
@property (readonly, strong, nonatomic) CAFMatchedTextViewModel *viewModel;
@property (strong, nonatomic) IBOutlet UIButton *addSourceButton;
@end
