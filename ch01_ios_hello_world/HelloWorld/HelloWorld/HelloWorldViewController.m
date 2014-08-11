//
//  HelloWorldViewController.m
//  HelloWorld
//
//  Created by Radek Tomasek on 8/11/14.
//  Copyright (c) 2014 seatcat.mobi. All rights reserved.
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
    /* Following two lines represent fairly standard URL request mechanism provided by Apple Core Foundation. SeaCat functionality is triggered by '.seacat' extension of URL host (see https://nodejshost.seacat/). Such a request is intercepted by SeaCat client, forwarded in secure way to SeaCat gateway and consequently to 'nodejshost' host.*/
    
    NSURL *url = [NSURL URLWithString:@"https://nodejshost.seacat/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    /* Parsing  of response in JSON format. */
    
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
