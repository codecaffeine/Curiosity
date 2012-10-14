//
//  CAFProviderSelectorViewController.m
//  Curiosity
//
//  Created by Matthew Thomas on 10/14/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import "CAFProviderSelectorViewController.h"

@interface CAFProviderSelectorViewController ()
@property (strong, nonatomic) IBOutlet UIView *gitHubTableHeader;
@property (strong, nonatomic) NSArray *gitHubActions;
@property (assign, nonatomic) BOOL isSignedIntoGitHub;
@end


@implementation CAFProviderSelectorViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Read Text from:",
                                   @"ProviderSelector title");
        
    // Build GitHub Action List
    NSMutableArray *gitHubActions = [NSMutableArray new];
    if (self.isSignedIntoGitHub) {
        [gitHubActions addObjectsFromArray:@[@"My Gists", @"My Favorited Gists"]];
    }
    [gitHubActions addObject:@"User Gists"];
    self.gitHubActions = gitHubActions;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.gitHubActions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row < [self.gitHubActions count]) {
        cell.textLabel.text = [self.gitHubActions objectAtIndex:indexPath.row];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.gitHubTableHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.gitHubTableHeader.bounds.size.height;
}

@end
