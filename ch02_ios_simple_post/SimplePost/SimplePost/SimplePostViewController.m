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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doPostRequest:(NSString *)stringMessage
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://nodejshost.seacat/"]];
    
    // set the POST method
    request.HTTPMethod = @"POST";
    
    // set the header file
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSData *requestBodyData = [stringMessage dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection)
    {
        NSLog(@"Message was sent to SeaCat Gateway");
    }
    else
    {
        NSLog(@"Connection with your Gateway was not successful");
    }
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
