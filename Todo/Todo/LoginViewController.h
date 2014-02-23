//
//  ViewController.h
//  Todo
//
//  Created by Ivan Bruel on 23/02/14.
//  Copyright (c) 2014 iOSOnRails. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

-(IBAction)loginClick:(UIButton *)sender;

@property(nonatomic, weak) IBOutlet UITextField* emailTextField;
@property(nonatomic, weak) IBOutlet UITextField* passwordTextField;

@end
