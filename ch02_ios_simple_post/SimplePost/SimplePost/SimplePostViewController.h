//
//  SimplePostViewController.h
//  SimplePost
//
//  Created by Radek Tomasek on 8/21/14.
//  Copyright (c) 2014 seatcat.mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimplePostViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
- (IBAction)mySendButton:(id)sender;

@end
