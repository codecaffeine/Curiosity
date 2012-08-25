//
//  CAFMasterViewController.h
//  Curiosity
//
//  Created by Matthew Thomas on 8/25/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CAFDetailViewController;

#import <CoreData/CoreData.h>

@interface CAFMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) CAFDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
