//
//  NewTaskViewController.m
//  Todo
//
//  Created by Ivan Bruel on 23/02/14.
//  Copyright (c) 2014 iOSOnRails. All rights reserved.
//

#import "NewTaskViewController.h"

@interface NewTaskViewController ()

@end

@implementation NewTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

#pragma mark - IBActions
-(void)newTaskClick:(UIBarButtonItem *)sender{
    NSString* title = [self.titleTextField text];
    // Show loader
    [SVProgressHUD showProgress:-1 status:@"Creating new task..."];
    
    // Create JSON
    NSDictionary* jsonDictionary = @{@"token": self.userToken, @"title": title};
    
    // GET Tasks from Server
    [[AFHTTPRequestOperationManager manager] POST:@"http://192.168.1.80:3000/"
                                       parameters:jsonDictionary
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              [self newTaskSuccessful];
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [self newTaskFailed];
                                          }];
    
}
#pragma mark - New Task Handler
-(void)newTaskSuccessful{
    // Hide the loader
    [SVProgressHUD dismiss];
    
    // Go to the todo screen
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)newTaskFailed{
    // Show error
    [SVProgressHUD showErrorWithStatus:@"Could not create the task."];
}

#pragma mark - UITextField Delegate
// Perform action upon return key press
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if(textField == self.titleTextField)
        [self newTaskClick:nil];
    return YES;
}
@end
