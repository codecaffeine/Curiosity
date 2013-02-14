//
//  CAFGitHubSignInViewController.m
//  CAFGitHub
//
//  Created by Matthew Thomas on 12/26/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import "CAFGitHubSignInViewController.h"
#import "CAFGitHubClient.h"


@interface CAFGitHubSignInViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelHeightConstraint;
@end


@implementation CAFGitHubSignInViewController {
    NSString *_errorMessage;
}
@dynamic errorMessage;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setErrorMessage:nil];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor underPageBackgroundColor];
}


#pragma mark - IBActions
- (IBAction)cancelPressed:(UIBarButtonItem *)sender
{
    if (self.cancelHandler) {
        self.cancelHandler();
    }
}

- (IBAction)signInPressed:(UIButton *)sender
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    if (self.signInHandler) {
        self.signInHandler(self.usernameField.text, self.passwordField.text);
    }
}

#pragma mark - Dynamic Properties
- (void)setErrorMessage:(NSString *)errorMessage
{
    _errorMessage = [errorMessage copy];
    self.errorMessageLabel.text = _errorMessage;
    [self.errorMessageLabel sizeToFit];
    self.labelHeightConstraint.constant = self.errorMessageLabel.frame.size.height;
    [self.errorMessageLabel needsUpdateConstraints];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [textField resignFirstResponder];
        [self signInPressed:nil];
    }
    
    return YES;
}


@end
