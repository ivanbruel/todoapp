//
//  TodoViewController.h
//  Todo
//
//  Created by Ivan Bruel on 23/02/14.
//  Copyright (c) 2014 iOSOnRails. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoViewController : UITableViewController

-(IBAction)logoutClick:(UIBarButtonItem*)sender;

@property(nonatomic, retain) NSString* userToken;

@end
