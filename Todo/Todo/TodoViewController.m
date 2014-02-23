//
//  TodoViewController.m
//  Todo
//
//  Created by Ivan Bruel on 23/02/14.
//  Copyright (c) 2014 iOSOnRails. All rights reserved.
//

#import "TodoViewController.h"
#import "Task.h"
@interface TodoViewController ()

@property(nonatomic,retain) NSArray* tasksArray;

@end

@implementation TodoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tasksArray = [NSArray new];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Load the tasks from the server every time the controller is shown
    [self tasksFromServer];
}
#pragma mark - IBActions
-(void)logoutClick:(UIBarButtonItem *)sender{
    // Go to the login screen upon logout
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - Tasks Handler
-(void)tasksFromServer{
    // Show the loader
    [SVProgressHUD showProgress:-1 status:@"Loading tasks..."];
}
-(void)tasksSucessfulWithJSON:(NSDictionary*)jsonDictionary{
    // Dismiss the loader
    [SVProgressHUD dismiss];
    
    // Create a mutable array to add the tasks
    NSMutableArray* tasksMutableArray = [NSMutableArray new];
    
    // Get the task array from the json
    NSArray* tasks = [jsonDictionary objectForKey:@"tasks"];
    
    // Iterate every task in the task array
    for(NSDictionary* taskDictionary in tasks){
        
        // Create the task from the json
        Task* task = [[Task alloc]initWithIdentifier:[taskDictionary objectForKey:@"id"]
                                           withTitle:[taskDictionary objectForKey:@"title"]
                                           withState:[taskDictionary objectForKey:@"state"]];
        
        // Add the task to the array
        [tasksMutableArray addObject:task];
    }
    
    // Assign the mutable array to the controller model array
    self.tasksArray = tasksMutableArray;
    
    // Reload the tableview for the new data
    [self.tableView reloadData];
}
-(void)tasksFailed{
    // Show error message
    [SVProgressHUD showErrorWithStatus:@"Could not load tasks."];
    
    // reset the tasks model array
    self.tasksArray = [NSArray new];
    
    // reload the tableview
    [self.tableView reloadData];
}
-(void)task:(Task*)task markAsDone:(BOOL)done{
    // Show the loader
    [SVProgressHUD showProgress:-1];
}
-(void)taskMarkSuccesful{
    // dismiss the loader
    [SVProgressHUD dismiss];
    
    // TODO get input from server
    
    // Deselect cell
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    
    // Reload the tableview
    [self.tableView reloadData];
}
-(void)taskMarkFailed{
    // show error message
    [SVProgressHUD showErrorWithStatus:@"Could not change the task's status."];
    
    // Deselect cell
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}
#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of tasks in the model array
    return self.tasksArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Resuse cell from tableview whenever possible
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    
    // If it does not exist, create a new uitableviewcell
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        [cell.textLabel setNumberOfLines:0];
    }
    
    // Get the task from the model array
    Task* task = [self.tasksArray objectAtIndex:indexPath.row];
    
    // Set the text on the textlabel
    cell.textLabel.text = task.title;
    
    // If it is done set the icon accordingly (using SDWebImage to get image from the web)
    if([task isDone])
        [cell.imageView setImageWithURL:[NSURL URLWithString:@"http://i.imgur.com/wptzHtf.png"]];
    else
        [cell.imageView setImageWithURL:[NSURL URLWithString:@"http://i.imgur.com/TceQZs6.png"]];
    
    // Return the cell
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Height for each row (TODO: calculate height according to text)
    return 140;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Task for selected cell
    Task* task = [self.tasksArray objectAtIndex:indexPath.row];
    
    // Switch task status
    [self task:task markAsDone:[task isDone]];
}

@end
