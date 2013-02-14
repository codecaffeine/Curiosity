//
//  CAFGitHubViewController.m
//  CAFGitHub
//
//  Created by Matthew Thomas on 12/9/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import "CAFGitHubViewController.h"
#import "CAFGistTableViewController.h"
#import "CAFGitHubSignInViewController.h"
#import "CAFGitHubClient.h"
#import "CAFGitHubDefines.h"
#import "CAFGitHubUser.h"


static NSString *const CAFGitHubViewControllerCell = @"CAFGitHubViewControllerCell";


@interface CAFGitHubViewController () <UIAlertViewDelegate>
@property (strong, nonatomic) NSArray *actions;
@property (strong, nonatomic) CAFGitHubClient *gitHubClient;
@property (strong, nonatomic) CAFGitHubUser *user;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *signInButton;
@end


@implementation CAFGitHubViewController {
    CAFGitHubUser *_user;
}
@dynamic user;

#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.gitHubClient = [[CAFGitHubClient alloc] init];
    [self updateUser];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.actions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CAFGitHubViewControllerCell
                                                            forIndexPath:indexPath];
    
    if (indexPath.row < [self.actions count]) {
        cell.textLabel.text = [self.actions objectAtIndex:indexPath.row];
    }
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PushGist"]) {
        if ([segue.destinationViewController isKindOfClass:[CAFGistTableViewController class]]) {
            CAFGistTableViewController *gistTableViewController = (CAFGistTableViewController *)segue.destinationViewController;
            
            NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
            NSUInteger selectedRow = (NSUInteger)selectedIndexPath.row;
            if (selectedRow < [self.actions count]) {
                NSString *selectedAction = [self.actions objectAtIndex:selectedRow];
                
                if ([selectedAction isEqualToString:@"Public Gists"]) {
                    [self.gitHubClient getPublicGistsWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *gists) {
                        gistTableViewController.gists = gists;
                    }
                                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                             NSLog(@"error: %@", error);
                                                         }];
                } else if ([selectedAction isEqualToString:@"My Gists"]) {
                    [self.gitHubClient getGistsWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *gists) {
                        gistTableViewController.gists = gists;
                    }
                                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                             NSLog(@"error: %@", error);
                                                         }];
                } else if ([selectedAction isEqualToString:@"My Starred Gists"]) {
                    [self.gitHubClient getStarredGistsWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *gists) {
                        gistTableViewController.gists = gists;
                    }
                                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                             NSLog(@"error: %@", error);
                                                         }];
                }
            }
        }
    } else if ([segue.identifier isEqualToString:@"SignInSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
            if ([navController.topViewController isKindOfClass:[CAFGitHubSignInViewController class]]) {
                CAFGitHubSignInViewController *signInViewController = (CAFGitHubSignInViewController *)navController.topViewController;
                [self presentSignInViewController:signInViewController];
            }
        }
    }
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"PushGist" sender:indexPath];
}


- (IBAction)signInPressed:(UIBarButtonItem *)sender
{
    if (self.user) {
        NSString *title = [NSString stringWithFormat:@"Sign Out From Account \u2018%@\u2019?", self.user.username];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel",
                                                                                      @"Sign Out Cancel Button Title")
                                                  otherButtonTitles:NSLocalizedString(@"Sign Out",
                                                                                      @"Sign Out Action Button Title"), nil];
        [alertView show];
    } else {
        [self performSegueWithIdentifier:@"SignInSegue" sender:self];
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.user = nil;
    }
}


#pragma mark - Property Accessors
- (CAFGitHubUser *)user
{
    return _user;
}


- (void)setUser:(CAFGitHubUser *)user
{
    _user = user;
    [self updateUser];
}


#pragma mark - Private Methods
- (void)updateUser
{
    if (self.user) {
        self.signInButton.title = self.user.username;
        self.actions = @[@"Public Gists", @"My Gists", @"My Starred Gists"];
        
    } else {
        self.signInButton.title = NSLocalizedString(@"Sign In",
                                                    "Sign In Button Title");
        self.actions = @[@"Public Gists"];
    }
    [self.tableView reloadData];
}


- (void)presentSignInViewController:(CAFGitHubSignInViewController *)signInViewController
{
    signInViewController.cancelHandler = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    signInViewController.signInHandler = ^(NSString *username,
                                           NSString *password) {
        [self.gitHubClient createOAuthTokenWithUsername:username
                                               password:password
                                               clientID:CAFGitHubClientID
                                           clientSecret:CAFGitHubClientSecret
                                                 scopes:@[@"user", @"gist"]
                                                success:^(AFHTTPRequestOperation *operation, NSString *oAuthToken) {
                                                    [self.gitHubClient setAuthorizationHeaderWithToken:oAuthToken];
                                                    [self.gitHubClient getUserWithSuccess:^(AFHTTPRequestOperation *operation,
                                                                                            CAFGitHubUser *user) {
                                                        self.user = user;
                                                        [self dismissViewControllerAnimated:YES completion:nil];
                                                    }
                                                                                  failure:^(AFHTTPRequestOperation *operation,
                                                                                            NSError *error) {
                                                        NSLog(@"Error: %@", error);
                                                    }];
                                                }
                                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                    NSLog(@"operation: %@", operation);
                                                    NSLog(@"error: %@", error);
                                                }];
    };
}



@end
