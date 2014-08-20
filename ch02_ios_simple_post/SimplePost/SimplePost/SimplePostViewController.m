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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doPostRequest:(NSString *)stringMessage
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:1337"]];
    
    // set the POST method
    request.HTTPMethod = @"POST";
    
    // set the header file
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSData *requestBodyData = [stringMessage dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (IBAction)mySendButton:(id)sender
{
    NSString *text = @"Hello Test";
    
    [self doPostRequest:text];
}
@end
