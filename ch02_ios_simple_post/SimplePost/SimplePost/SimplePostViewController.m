//
//  SimplePostViewController.m
//  SimplePost
//
//  Created by Radek Tomasek on 8/21/14.
//  Copyright (c) 2014 seatcat.mobi. All rights reserved.
//

#import "SimplePostViewController.h"

@interface SimplePostViewController ()

@end

@implementation SimplePostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.myTextField becomeFirstResponder];
}

- (void)doPostRequest:(NSString *)stringMessage
{
    NSString *bodyData = [stringMessage stringByAppendingString:@"=was sent by POST (and read in node.js)"];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://nodejshost.seacat/"]];
    
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    
    [NSURLConnection connectionWithRequest:postRequest delegate:self];
}

- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [theTextField.text stringByReplacingCharactersInRange:range withString:string];

    self.sendButton.enabled = ([newText length] > 0);
    
    return YES;
}


- (IBAction)mySendButton:(id)sender
{
    [self doPostRequest:[self.myTextField text]];
    
    [self.myTextField resignFirstResponder];
}
@end
