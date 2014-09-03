//
//  SimplePostViewController.h
//  SimplePost
//
//  Created by Radek Tomasek on 9/2/14.
//  Copyright (c) 2014 seatcat.mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimplePostViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (weak, nonatomic) IBOutlet UIButton *mySendButton;
- (IBAction)sendAction:(id)sender;

@end
