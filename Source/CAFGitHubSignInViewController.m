//
//  CAFGitHubSignInViewController.m
//  Curiosity
//
//  Created by Matthew Thomas on 10/14/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import "CAFGitHubSignInViewController.h"

@interface CAFGitHubSignInViewController () <UITextFieldDelegate, NSURLConnectionDataDelegate>
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) NSURLConnection *authenticationConnection;
@property (strong, nonatomic) NSMutableData *authenticationData;
@end


@implementation CAFGitHubSignInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"GitHub Sign in", @"GitHub Sign in title");
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [textField resignFirstResponder];
        [self signIn];
    }
    return YES;
}


#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    NSLog(@"connection:%@ didFailWithError:%@", connection, error);
    self.authenticationConnection = nil;
    self.authenticationData = nil;
}


- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"\n\nconnection: didReceiveResponse:");
    NSLog(@"\t expectedContentLength:%lld", [response expectedContentLength]);
    NSLog(@"\t suggestedFilename:%@", [response suggestedFilename]);
    NSLog(@"\t textEncodingName:%@", [response textEncodingName]);
    NSLog(@"\t URL:%@", [response URL]);
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"\t statusString:%@", [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
        NSLog(@"\t URL:%d", [httpResponse statusCode]);
        NSLog(@"\t allHeaderFields:%@", [httpResponse allHeaderFields]);
    }
    self.authenticationData = [NSMutableData data];
}


- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    [self.authenticationData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *jsonSerializatonError;
    NSLog(@"self.authenticationData: %@", self.authenticationData);
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:self.authenticationData
                                                             options:0
                                                               error:&jsonSerializatonError];
    if (response) {
        NSLog(@"response: %@", response);
    } else {
        NSLog(@"jsonSerializatonError: %@", jsonSerializatonError);
    }
}


- (void)connection:(NSURLConnection *)connection
willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] < 1) {
        if ([[challenge protectionSpace] authenticationMethod] == NSURLAuthenticationMethodServerTrust) {
            [[challenge sender] rejectProtectionSpaceAndContinueWithChallenge:challenge];
        } else {
            NSURLCredential *credential;
            credential = [NSURLCredential credentialWithUser:self.usernameField.text
                                                    password:self.passwordField.text
                                                 persistence:NSURLCredentialPersistenceForSession];
            [[challenge sender] useCredential:credential
                   forAuthenticationChallenge:challenge];
        }
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"username/password wrong"
                                           message:nil
                                          delegate:nil
                                 cancelButtonTitle:@"Okay"
                                 otherButtonTitles:nil];
        [alert show];
    }
}

//- (BOOL)connection:(NSURLConnection *)connection
//canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
//{
//    NSLog(@"\n\nconnection: canAuthenticateAgainstProtectionSpace:");
//    NSLog(@"\t authenticationMethod: %@", [protectionSpace authenticationMethod]);
//    NSLog(@"\t distinguishedNames: %@", [protectionSpace distinguishedNames]);
//    NSLog(@"\t host: %@", [protectionSpace host]);
//    NSLog(@"\t isProxy: %@", [protectionSpace isProxy] ? @"YES" : @"NO");
//    NSLog(@"\t port: %d", [protectionSpace port]);
//    NSLog(@"\t protocol: %@", [protectionSpace protocol]);
//    NSLog(@"\t proxyType: %@", [protectionSpace proxyType]);
//    NSLog(@"\t realm: %@", [protectionSpace realm]);
//    return YES;
//}
//
//
//
//- (void)connection:(NSURLConnection *)connection
//didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//    NSLog(@"\n\nconnection: didReceiveAuthenticationChallenge:");
//    NSLog(@"\t error: %@", [challenge error]);
//    NSLog(@"\t failureResponse: %@", [challenge failureResponse]);
//    NSLog(@"\t previousFailureCount: %d", [challenge previousFailureCount]);
//    NSLog(@"\t proposedCredential: %@", [challenge proposedCredential]);
//    NSLog(@"\t protectionSpace: %@", [challenge protectionSpace]);
//    NSLog(@"\t sender: %@", [challenge sender]);
//    if ([challenge previousFailureCount] < 1) {
//        NSURLCredential *credential;
//        credential = [NSURLCredential credentialWithUser:self.usernameField.text
//                                                password:self.passwordField.text
//                                             persistence:NSURLCredentialPersistenceForSession];
//        [[challenge sender] useCredential:credential
//               forAuthenticationChallenge:challenge];
//    } else {
//        [[challenge sender] cancelAuthenticationChallenge:challenge];
//        UIAlertView *alert;
//        alert = [[UIAlertView alloc] initWithTitle:@"username/password wrong"
//                                           message:nil
//                                          delegate:nil
//                                 cancelButtonTitle:@"Okay"
//                                 otherButtonTitles:nil];
//        [alert show];
//    }
//}


#pragma mark - Instance Methods
- (void)signIn
{
    NSDictionary *authDict = @{
        @"scopes": @[@"gists"],
        @"note": @"Curiosity App"
    };
    NSError *jsonEncodeError;
    NSData *jsonObject = [NSJSONSerialization dataWithJSONObject:authDict
                                                         options:0
                                                           error:&jsonEncodeError];
        
    if (jsonObject) {
        NSURL *url = [NSURL URLWithString:@"https://api.github.com/gists"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//        [request setHTTPMethod:@"POST"];
//        [request setHTTPBody:jsonObject];
        
        self.authenticationConnection = [NSURLConnection connectionWithRequest:request
                                                                      delegate:self];
    } else {
        NSLog(@"jsonEncodeError: %@", jsonEncodeError);
    }
}


- (IBAction)signInPressed:(UIButton *)sender
{
    [self signIn];
}

@end
