//
//  CAFGistTableViewController.h
//  Curiosity
//
//  Created by Matthew Thomas on 9/23/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CAFGistTableViewControllerDelegate;

@interface CAFGistTableViewController : UITableViewController
@property (weak, nonatomic) id<CAFGistTableViewControllerDelegate> delegate;
@end


@protocol CAFGistTableViewControllerDelegate <NSObject>
- (void)gistTableViewController:(CAFGistTableViewController *)gistTableViewController
                   didReturnURL:(NSURL *)url;
@end
