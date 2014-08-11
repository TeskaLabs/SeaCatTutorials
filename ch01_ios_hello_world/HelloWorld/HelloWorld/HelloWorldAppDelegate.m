//
//  HelloWorldAppDelegate.m
//  HelloWorld
//
//  Created by Radek Tomasek on 8/11/14.
//  Copyright (c) 2014 seatcat.mobi. All rights reserved.
//

#import "HelloWorldAppDelegate.h"
#import <SeaCatClientTrial/SeaCat.h>

@implementation HelloWorldAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:	(NSDictionary *)launchOptions
{
    /* This method finalises SeaCat client initial configuration. It also ensures that client is integrated with Core Foundation URL Loading System (check Apple URLLoadingSystem in documentation for more information). So all URL requests are intercepted, analysed and eventually processed by SeaCat gateway instead of common HTTP transport. */
    
    [SeaCatClient configure];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
