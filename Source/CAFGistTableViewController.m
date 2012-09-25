//
//  CAFGistTableViewController.m
//  Curiosity
//
//  Created by Matthew Thomas on 9/23/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import "CAFGistTableViewController.h"

NSString *const CAFGistCellIdentifier = @"CAFGistCellIdentifier";

@interface CAFGistTableViewController ()
@property (copy, nonatomic) NSArray *gists;
@property (assign, nonatomic) NSStringEncoding encoding;
@end


@implementation CAFGistTableViewController

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
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CAFGistCellIdentifier];
    
    NSURL *url = [NSURL URLWithString:@"https://api.github.com/users/codecaffeine/gists"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPShouldUsePipelining:YES];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               if (data) {
                                   CFStringRef encodingName = (__bridge CFStringRef)[response textEncodingName];
                                   CFStringEncoding ianaCharSetName = CFStringConvertIANACharSetNameToEncoding(encodingName);
                                   self.encoding = CFStringConvertEncodingToNSStringEncoding(ianaCharSetName);
                                   NSLog(@"self.encoding: %d", self.encoding);
                                   NSError *jsonSerializationError;
                                   id serializedJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                                       options:0
                                                                                         error:&jsonSerializationError];
                                   if (serializedJSON && [serializedJSON isKindOfClass:[NSArray class]]) {
                                       self.gists = (NSArray *)serializedJSON;
                                       NSLog(@"gists: %@", self.gists);
                                       [self.tableView reloadData];
                                   } else if (jsonSerializationError) {
                                       NSLog(@"jsonSerializationError: %@", jsonSerializationError);
                                   }
                               } else if (error) {
                                   NSLog(@"error: %@", error);
                               }
                           }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.gists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CAFGistCellIdentifier
                                                            forIndexPath:indexPath];    
    if (indexPath.row < self.gists.count) {
        NSDictionary *currentGist = [self.gists objectAtIndex:indexPath.row];
        cell.textLabel.text = [currentGist objectForKey:@"description"];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.gists.count) {
        NSDictionary *currentGist = [self.gists objectAtIndex:indexPath.row];
        id filesObject = [currentGist objectForKey:@"files"];
        if ([filesObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *files = (NSDictionary *)filesObject;
            NSLog(@"files: %@", files);
            NSArray *allKeys = [files allKeys];
            if ([allKeys count] == 1 && [[allKeys lastObject] isKindOfClass:[NSString class]]) {
                NSString *fileName = [allKeys lastObject];
                id fileInfoObject = [files objectForKey:fileName];
                NSLog(@"%@ = %@", fileName, fileInfoObject);
                if ([fileInfoObject isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *fileInfo = (NSDictionary *)fileInfoObject;
                    NSString *fileURLString = [[fileInfo objectForKey:@"raw_url"] stringByAddingPercentEscapesUsingEncoding:self.encoding];
                    NSURL *fileURL = [NSURL URLWithString:fileURLString];
                    NSLog(@"fileURL: %@", fileURL);
                    [self.delegate gistTableViewController:self
                                              didReturnURL:fileURL];
                }
            } else {
                NSLog(@"why are there more than one ? %@", allKeys);
            }
        }
    }
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
