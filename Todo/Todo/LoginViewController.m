//
//  ViewController.m
//  Todo
//
//  Created by Ivan Bruel on 23/02/14.
//  Copyright (c) 2014 iOSOnRails. All rights reserved.
//

#import "LoginViewController.h"
#import "TodoViewController.h"

@interface LoginViewController ()

@property(nonatomic,strong) NSString* userToken;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - IBActions
-(void)loginClick:(UIButton *)sender{
    NSString* email = [self.emailTextField text];
    NSString* password = [self.passwordTextField text];
    
    // Create JSON
    NSDictionary* userDictionary = @{@"email": email,
                                     @"password": password};
    
    NSDictionary* jsonDictionary = @{@"user":userDictionary};
    
    // Show loader
    [SVProgressHUD showProgress:-1 status:@"Logging in..."];
    
    // POST Login to Server
    [[AFHTTPRequestOperationManager manager] POST:@"http://192.168.1.144:3000/v1/users/sign_in.json"
                                       parameters:jsonDictionary
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           [self loginSuccessfulWithUserToken:[responseObject objectForKey:@"authentication_token"]];
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           [self loginFailed];
                                       }];
}

#pragma mark - Login Handler
-(void)loginSuccessfulWithUserToken:(NSString*)userToken{
    // Set the token
    self.userToken = userToken;
    
    // Hide the loader
    [SVProgressHUD dismiss];
    
    // Go to the Todo View Controller
    [self performSegueWithIdentifier:@"todoSegue" sender:self];
}
-(void)loginFailed{
    self.userToken = nil;
    
    // Show Error message
    [SVProgressHUD showErrorWithStatus:@"Could not login. Please re-check your credentials."];
}

#pragma mark - Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier]isEqualToString:@"todoSegue"]){
        
        // Set the user token on the next screen
        TodoViewController* todoViewController = [segue destinationViewController];
        todoViewController.userToken = self.userToken;
    }
}

#pragma mark - UITextField Delegate
// Go to next textfield upon clicking the return key (perform action if no other textfield)
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.emailTextField)
        [self.passwordTextField becomeFirstResponder];
    if(textField == self.passwordTextField)
        [self loginClick:nil];
    return YES;
}
@end
