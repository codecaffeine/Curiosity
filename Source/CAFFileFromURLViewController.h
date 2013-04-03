//
//  CAFFileFromURLViewController.h
//  Curiosity
//
//  Created by Matthew Thomas on 4/2/13.
//  Copyright (c) 2013 Matthew Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAFFileFromURLViewController : UIViewController
@property (readonly, copy, nonatomic) NSString *filename;
@property (readonly, copy, nonatomic) NSString *fileContents;
@end
