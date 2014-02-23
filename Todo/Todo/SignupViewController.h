//
//  SignupViewController.h
//  Todo
//
//  Created by Ivan Bruel on 23/02/14.
//  Copyright (c) 2014 iOSOnRails. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController<UITextFieldDelegate>

-(IBAction)signupClick:(UIButton *)sender;

@property(nonatomic, weak) IBOutlet UITextField* emailTextField;
@property(nonatomic, weak) IBOutlet UITextField* passwordTextField;

@end
