//
//  HelloWorldAppViewController.m
//  HelloWorldApp
//
//  Created by Radek Tomasek on 8/9/14.
//  Copyright (c) 2014 seatcat.mobi. All rights reserved.
//

#import "HelloWorldAppViewController.h"

@interface HelloWorldAppViewController ()

@end

@implementation HelloWorldAppViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self fetchGreeting];
}



- (void)fetchGreeting
{
    NSURL *url = [NSURL URLWithString:@"http://nodejshost.seacat/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest: request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data,NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data options: 0 error:NULL];
             self.result.text = [greeting objectForKey:@"message"];
         }
     }];
}

@end
