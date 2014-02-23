//
//  SignupViewController.m
//  Todo
//
//  Created by Ivan Bruel on 23/02/14.
//  Copyright (c) 2014 iOSOnRails. All rights reserved.
//

#import "SignupViewController.h"
#import "TodoViewController.h"
@interface SignupViewController ()

@property(nonatomic,retain) NSString* userToken;

@end

@implementation SignupViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - IBActions
-(void)signupClick:(UIButton *)sender{
    NSString* email = [self.emailTextField text];
    NSString* password = [self.passwordTextField text];
    // Show loader
    [SVProgressHUD showProgress:-1 status:@"Signing up..."];
}

#pragma mark - Signup Handler
-(void)signupSuccessfulWithUserToken:(NSString*)userToken{
    // set the user token
    self.userToken = userToken;
    
    // Hide the loader
    [SVProgressHUD dismiss];
    
    // Go to the Todo View Controller
    [self performSegueWithIdentifier:@"todoSegue" sender:self];
}
-(void)signupFailed{
    // Show Error message
    [SVProgressHUD showErrorWithStatus:@"Could not signup. Please re-check your credentials."];
}

#pragma mark - Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier]isEqualToString:@"todoSegue"]){
        TodoViewController* todoViewController = [segue destinationViewController];
        todoViewController.userToken = self.userToken;
    }
}

#pragma mark - UITextField Delegate
// Go to next textfield upon clicking the return key (perform action if no other textfield)
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if(textField == self.emailTextField)
        [self.passwordTextField becomeFirstResponder];
    if(textField == self.passwordTextField)
        [self signupClick:nil];
    return YES;
}
@end
