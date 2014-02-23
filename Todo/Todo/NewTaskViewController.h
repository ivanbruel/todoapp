//
//  NewTaskViewController.h
//  Todo
//
//  Created by Ivan Bruel on 23/02/14.
//  Copyright (c) 2014 iOSOnRails. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTaskViewController : UIViewController

-(IBAction)newTaskClick:(UIBarButtonItem*)sender;

@property(nonatomic, weak) IBOutlet UITextField* titleTextField;
@property(nonatomic,strong) NSString* userToken;

@end
