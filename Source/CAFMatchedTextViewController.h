//
//  CAFMatchedTextViewController.h
//  Curiosity
//
//  Created by Matthew Thomas on 8/26/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CAFMatchedTextViewControllerDelegate;

@interface CAFMatchedTextViewController : UIViewController
@property (copy, nonatomic) NSString *regexString;
@property (copy, nonatomic) NSString *inputText;
@property (weak, nonatomic) id<CAFMatchedTextViewControllerDelegate> delegate;
- (IBAction)cancelledImportingFile:(UIStoryboardSegue *)segue;
- (IBAction)doneImportingFile:(UIStoryboardSegue *)segue;
@end



@protocol CAFMatchedTextViewControllerDelegate <NSObject>
- (void)matchedTextViewController:(CAFMatchedTextViewController *)matchedTextViewController
                    shouldLoadURL:(NSURL *)url;
@end
