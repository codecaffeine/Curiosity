//
//  CAFGitHubSignInViewController.m
//  Curiosity
//
//  Created by Matthew Thomas on 10/14/12.
//  Copyright (c) 2012 Matthew Thomas. All rights reserved.
//

#import "CAFGitHubSignInViewController.h"


@interface NSString (NSStringAdditions)
+ (NSString *) base64StringFromData:(NSData *)data length:(int)length;
@end



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
//        if ([[challenge protectionSpace] authenticationMethod] == NSURLAuthenticationMethodServerTrust) {
//            [[challenge sender] rejectProtectionSpaceAndContinueWithChallenge:challenge];
//        } else {
            NSURLCredential *credential;
//        NSString *username = [NSString base64StringFromData:[self.usernameField.text dataUsingEncoding:NSUTF8StringEncoding]
//                                                     length:self.usernameField.text.length];

        NSString *username = self.usernameField.text;

//        NSString *password = [NSString base64StringFromData:[self.passwordField.text dataUsingEncoding:NSUTF8StringEncoding]
//                                                        length:self.passwordField.text.length];
        
        NSString *password = self.passwordField.text;

            credential = [NSURLCredential credentialWithUser:username
                                                    password:password
                                                 persistence:NSURLCredentialPersistenceNone];
            [[challenge sender] useCredential:credential
                   forAuthenticationChallenge:challenge];
//        }
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
        @"note": @"Curiosity App",
        @"note_url": @"http://codecaffeine.com"
    };
    NSError *jsonEncodeError;
    NSData *jsonObject = [NSJSONSerialization dataWithJSONObject:authDict
                                                         options:0
                                                           error:&jsonEncodeError];
        
    if (jsonObject) {
        NSURL *url = [NSURL URLWithString:@"https://api.github.com/authorizations"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                           timeoutInterval:30.0];
        
//        NSString *usernamePassword = [NSString stringWithFormat:@"%@:%@",
//                                      self.usernameField.text,
//                                      self.passwordField.text];
//        NSString *encodedUsernamePassword = [NSString base64StringFromData:[usernamePassword dataUsingEncoding:NSUTF8StringEncoding]
//                                                                    length:[usernamePassword length]];
//        
//        [request setValue:[NSString stringWithFormat:@"Basic %@", encodedUsernamePassword]
//       forHTTPHeaderField:@"Authorization"];
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:jsonObject];
        
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


static char base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

@implementation NSString (NSStringAdditions)

+ (NSString *)base64StringFromData:(NSData *)data length:(int)length
{
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }     
    return result;
}

@end
