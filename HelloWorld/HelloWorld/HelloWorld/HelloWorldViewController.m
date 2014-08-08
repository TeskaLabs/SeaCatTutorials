//
//  HelloWorldViewController.m
//  HelloWorld
//
//  Created by Radek Tomasek on 8/6/14.
//  Copyright (c) 2014 codeforios.com. All rights reserved.
//

#import "HelloWorldViewController.h"

@interface HelloWorldViewController ()

@end

@implementation HelloWorldViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self fetchGreeting];
}

- (void)fetchGreeting
{
    NSURL *url = [NSURL URLWithString:@"http://myenvironment.seacat/greeting/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest: request
                                       queue:[NSOperationQueue mainQueue]
                        completionHandler:^(NSURLResponse *response, NSData *data,NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil) {
             NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data options: 0 error:NULL];
             self.result.text = [greeting objectForKey:@"message"];
         }
     }];
}

@end
