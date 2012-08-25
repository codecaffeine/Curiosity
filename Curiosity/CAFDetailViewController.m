//
//  CAFDetailViewController.m
//  Curiosity
//
//  Created by Matthew Thomas on 8/25/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import "CAFDetailViewController.h"


@interface CAFDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end


@implementation CAFDetailViewController

#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Property Accessors
- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}


#pragma mark - Private Methods
- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        id timeStampValue = [self.detailItem valueForKey:@"timeStamp"];
        self.detailDescriptionLabel.text = [timeStampValue description];
    }
}


#pragma mark - UISplitViewControllerDelegate
- (void)splitViewController:(UISplitViewController *)splitController
     willHideViewController:(UIViewController *)viewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}


- (void)splitViewController:(UISplitViewController *)splitController
     willShowViewController:(UIViewController *)viewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the
    // button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
