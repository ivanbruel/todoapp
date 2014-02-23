//
//  NewTaskViewController.h
//  Todo
//
//  Created by Ivan Bruel on 23/02/14.
//  Copyright (c) 2014 iOSOnRails. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTaskViewController : UITableViewController

-(IBAction)newTaskClick:(UIBarButtonItem*)sender;

@property(nonatomic, weak) IBOutlet UITextField* titleTextField;
@property(nonatomic, weak) IBOutlet UITextField* descriptionTextField;


@end
