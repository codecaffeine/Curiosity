//
//  CAFGistViewController.m
//  CAFGitHub
//
//  Created by Matthew Thomas on 12/9/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import "CAFGistViewController.h"


@interface CAFGistViewController ()
@property (strong, nonatomic) IBOutlet UILabel *idLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *urlLabel;
@property (strong, nonatomic) IBOutlet UILabel *fileCountLabel;
@end


@implementation CAFGistViewController {
    CAFGist *_gist;
}
@dynamic gist;


#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}


#pragma mark - Accessor Methods
- (CAFGist *)gist
{
    return _gist;
}


- (void)setGist:(CAFGist *)gist
{
    NSLog(@"gist: %@", gist);
    _gist = gist;
    [self updateUI];
}


#pragma mark - Private Methods
- (void)updateUI
{
    self.idLabel.text = self.gist.identifier;
    self.descriptionLabel.text = self.gist.desc;
    self.urlLabel.text = [self.gist.url absoluteString];
    self.fileCountLabel.text = [NSString stringWithFormat:@"%d", [self.gist.files count]];
}


@end
