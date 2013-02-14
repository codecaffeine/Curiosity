//
//  CAFGistViewController.h
//  CAFGitHub
//
//  Created by Matthew Thomas on 12/9/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAFGist.h"

@interface CAFGistViewController : UITableViewController
@property (strong, nonatomic) CAFGist *gist;
@end
