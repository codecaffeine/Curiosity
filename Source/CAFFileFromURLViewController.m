//
//  CAFFileFromURLViewController.m
//  Curiosity
//
//  Created by Matthew Thomas on 4/2/13.
//  Copyright (c) 2013 Matthew Thomas. All rights reserved.
//

#import "CAFFileFromURLViewController.h"
#import "CAFFileURLClient.h"

@interface CAFFileFromURLViewController ()
@property (copy,   nonatomic) NSString *filename;
@property (copy,   nonatomic) NSString *fileContents;
@property (strong, nonatomic) IBOutlet UITextField *urlField;
@property (strong, nonatomic) IBOutlet UIButton *goButton;
@end

@implementation CAFFileFromURLViewController
- (IBAction)goPressed:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:self.urlField.text];
    CAFFileURLClient *client = [[CAFFileURLClient alloc] initWithBaseURL:url];
    [client getFileAtPath:nil
                  success:^(AFHTTPRequestOperation *operation, NSString *filename, NSString *fileContents) {
                      self.filename = filename;
                      self.fileContents = fileContents;
                      [self performSegueWithIdentifier:@"DoneImportingFileSegue" sender:operation];
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"Error: %@", error);
                  }];
}
@end
