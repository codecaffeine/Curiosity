//
//  CAFGistTableViewController.m
//  CAFGitHub
//
//  Created by Matthew Thomas on 12/11/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import "CAFGistTableViewController.h"
#import "CAFGist.h"
#import "CAFGistViewController.h"


static NSString *const CAFGistTableViewCell = @"CAFGistTableViewCell";


@implementation CAFGistTableViewController {
    NSArray *_gists;
}
@dynamic gists;


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.gists count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CAFGistTableViewCell
                                                            forIndexPath:indexPath];
    
    if (indexPath.row < [self.gists count]) {
        CAFGist *gist = [self.gists objectAtIndex:indexPath.row];
        cell.textLabel.text = ([gist.desc length] > 0) ? gist.desc : gist.identifier;
        cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:gist.dateCreated
                                                                   dateStyle:NSDateFormatterShortStyle
                                                                   timeStyle:NSDateFormatterShortStyle];
    }
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[CAFGistViewController class]]) {
        CAFGistViewController *gistViewController = (CAFGistViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if (indexPath.row < [self.gists count]) {
            CAFGist *gist = [self.gists objectAtIndex:indexPath.row];
            gistViewController.gist = gist;
        }
    }
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Property Accessors
- (NSArray *)gists
{
    return _gists;
}


- (void)setGists:(NSArray *)gists
{
    _gists = [gists copy];
    [self.tableView reloadData];
}


@end
