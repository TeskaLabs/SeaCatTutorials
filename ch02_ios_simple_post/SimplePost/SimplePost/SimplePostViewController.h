//
//  SimplePostViewController.h
//  SimplePost
//
//  Created by Radek Tomasek on 8/21/14.
//  Copyright (c) 2014 seatcat.mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimplePostViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
- (IBAction)mySendButton:(id)sender;

@end
