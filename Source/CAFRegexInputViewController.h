//
//  CAFRegexInputViewController.h
//  Curiosity
//
//  Created by Matthew Thomas on 8/26/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CAFRegexInputViewControllerDelegate;

@interface CAFRegexInputViewController : UIViewController
@property (weak, nonatomic) id<CAFRegexInputViewControllerDelegate> delegate;
@end

@protocol CAFRegexInputViewControllerDelegate <NSObject>
- (void)regexInputViewController:(CAFRegexInputViewController *)regexInputViewController
              regexTextViewDidChange:(UITextView *)regexTextView;
@end