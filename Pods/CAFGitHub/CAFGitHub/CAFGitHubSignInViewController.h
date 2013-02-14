//
//  CAFGitHubSignInViewController.h
//  CAFGitHub
//
//  Created by Matthew Thomas on 12/26/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CAFSignInHandler)(NSString *username, NSString *password);

@interface CAFGitHubSignInViewController : UITableViewController
@property (copy, nonatomic) CAFSignInHandler signInHandler;
@property (copy, nonatomic) dispatch_block_t cancelHandler;
@property (copy, nonatomic) NSString *errorMessage;
@end
