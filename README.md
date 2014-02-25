# iOS on Rails - Part II
This guide assumes that you already have a **MacBook** running at least OSX (**Mountain Lion**) and have **Xcode 5** installed.

## Step 0 - Introduction
iOS is a mobile platform developed by Apple and is one of the most robust mobile platforms.
iOS development is mostly done on **Xcode** (IDE) and the programming language is Objective-C.
Objective-C is an **object-oriented programming language** based on C. 

Methods (or messages) have quite a different structure from what you have in C.

```cpp
obj->method(color,size);
``` 

```objc
[obj methodWithColor:color withSize:size];
```

The iOS Framework brings a whole lot more than just the Objective-C language, new Frameworks for controlling the mobile capabilities of your device, but also very popular and powerful OSX frameworks such as CoreData. 

Most of iOS development is done with the **MVC design pattern** (Model-View Controller) in mind, therefore an application will be divided into **Model** which contains the classes that contain the data your app will manipulate; **View** which refers to the visual part of iOS, where you create views to display your data; and **Controller** which is the middle ground between your data and your views, the controller manipulate the data and display it properly on the views, but will also receive input from the views and convert/manipulate into data.

![MVC Model](http://blogs.msdn.com/cfs-filesystemfile.ashx/__key/communityserver-blogs-components-weblogfiles/00-00-01-13-13-metablogapi/7024.espbyhyv_5F00_2.jpg)

## Step 1 - A New Project

For this workshop we are creating a network-based Todo list app with authentication.

Open up **Xcode**, click **Create a new Project** and select **iOS** and then **Single View Application**.
Set your product name to **Todo** and fill the Organization Name and Company Identifier whichever way pleases you.

Set the Devices to **iPhone** and leave the **Use Core Data** unchecked as we will not be using CoreData today. That would be a workshop on its own.

Select the folder to which you would like to save the project and press **Create**.

You will then land on the **Target**'s General Settings, and under Identity you can define the app version, build number and your development team (for code-signing purposes). The Deployment Info is the section where you can define the iOS version of your application, which devices it will deploy to (iPhone,iPad or both), which orientations the app will support, and the color of the status bar upon launch. 

For this app we will only want to use the **Portrait** orientation, please uncheck any other Device Orientations.

Under the next two sections you can define which resource shall be used for the **App Icon** and which should be used for the **Splash Screen**.

Last but not least, we have the **Frameworks** section, where you can import which iOS (and external) frameworks your application will use. (If you do not have **cocoapods** installed please click the **+** sign and add **CoreGraphics**, **MobileCoreServices**, **Security** and **SystemConfiguration** frameworks, otherwise the app will not compile when we use the **AFNetworking** framework).

## Step 1.1 - Project Structure

![Project Structure](http://i.imgur.com/vFHX9hg.png)

>Even though this kind of project structure does not come as default, I find that it is a better alternative to organize and structure your code project-wise. (You will have to create the folder structure in Xcode if you want it to look like that).

### Project Root

In the **Project Root** you can configure most of the application's settings, such as, permitted **device orientations**, **app icon**, **splash images**, etc.

### Application Delegate

The **AppDelegate** focuses on allowing the developer to control his application through **lifecycle** callbacks for when the application is launched or when it goes into foreground/background. This class is mostly used to initialize what you might need **globally** throughout the application. 

### Model
The **Model** is where classes should be created for containing the data which should be handle by the application. In this case the model will only contain **Tasks**.

A Model Class might contain **custom initializers**, **public and private properties** and **public and private methods**.


### Storyboard
![Storyboard](http://i.imgur.com/mMdBIp3.png)

The storyboard is the equivalent of the **View** in the **Model View Controller** design pattern.

In the **storyboard** you can design the **application's workflow** by creating a chain of **View Controllers** that can interact with each other through **segues**. In each view controller on the storyboard you will be able to design the view hierarchy by dragging and dropping views from the bottom right corner of the storyboard screen. These views should later be connected to the **Controller** through the use of **IBActions** and **IBOutlets**.

### View Controllers

The **View controllers** are the equivalent of the **controller** in the **Model View Controller** design pattern.

In each view controller you will be able to control its own **lifecycle**, **interface interaction** and **delegate callbacks**. 

Interface interaction should be controlled through the **IBActions** defined and the **IBOutlets**. IBActions are what happens normally when you **click** something. IBOutlets are variables assigned to views, in order to manipulate the **UI** according to the controller.

The controller might also have access to the **Model**, in order to display information accordingly.

### Assets
In the **.xcassets** file you will have your image resources for the application's UI. These images **must** always include two versions, a normal and a retina one. (e.g. image.png and image@2x.png).


## Step 2 - Model

Since this app focuses on tasks, let's model a **Task class** for the app to use.
Right click your **Todo** folder and click **New File...**, under **iOS** select Objective-C class and click **next**.
Set the name of the class as **Task** and be sure to subclass **NSObject**, click **next** and then **Create**.

You will now have 2 new files on your project, **Task.h** and **Task.m**. Let's go over to Task.h and start adding properties to our tasks.

A Task object will need 3 things, an **identifier** (to identify the task on the server side), a **title** and a status **isDone** (to let us know if we've done the task or not). Let's add those 3 properties to the **Task.h** file.

```objc
// Public model properties
@property(nonatomic, strong) NSNumber* identifier;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, readwrite) BOOL isDone;
```

**@property** creates a new property on the class, automatically creating the setter and getter for said property.

**nonatomic** means you do not want to guarantee thread-safety (which is faster in terms of get/set performance and we do not required thread safety).

**strong** means an object created from the class will keep the property value until it is set to something else or the actual task object is destroyed. (an alternative would be  **weak** where the property might lose value when no other strong pointers are set to the same NSString/NSNumber object).

**readwrite** differs from **strong/weak** in the sense that it can only be used to primary types such as **BOOL**, **int**, **CGFloat**, etc. (you can possibly set as **readonly** as well).

**NSNumber** is a number "super-class", which can handle any kind of numeric or boolean value.

**NSString** is the equivalent of a String object in many other languages.

>Bear in mind that in Objective-C there is a difference between **mutable** and **unmutable** objects, e.g. NSArray and NSMutableArray, where you can add objects to an NSMutableArray object but you cannot add them to an NSArray (Objects must be added on the NSArray initWithObjects: method) 

Since we have 3 properties that will need to be set when a **Task** object is created, let's define the initializer.

```objc
// Custom Initializer
-(id)initWithIdentifier:(NSNumber*)identifier
              withTitle:(NSString*)title
                 isDone:(BOOL)isDone;
```

As I said before, methods (or messages) are defined and used differently from other languages, it provides a more verbose way to look at code. This method reads as "Task, initialize with an identifier, a title, and a done status".

Now that we have defined the header file, let's go over to the implementation file, **Task.m**.

The only function defined manually on our model shall be the custom initializer, where you create and assign the **self** (equivalent of **this** in JAVA) to the default initializer of **NSObject**, and then we set the self properties to the values passed on the message.

```objc
-(id)initWithIdentifier:(NSNumber *)identifier 
              withTitle:(NSString *)title
                 isDone:(BOOL)isDone{
                 
    if ((self = [super init]))
    {
        self.identifier = identifier;
        self.title = title;
        self.isDone = isDone;
    }
    return self;
}
```

So, the Model is set, let's change our focus for a bit.


## Step 3 - Storyboard
Since this is a highly visual and drag-and-drop experience, I will not go through it in this tutorial (although it will be included in the workshop itself). 

The best way for you to work with **Storyboards** is trial and error, so feel free to drag and drop views and view controllers around.

## Step 4 - LoginViewController

To create a new view controller **right click** the **Todo** folder and press **New File...** , select **Objective-C class**, set the **Subclass of** to **UIViewController** and the Class name to **LoginViewController**. Leave both boxes unchecked as we will not need them.

On this controller we want to have a basic login interaction, with an **email** and **password** fields, a **login** button and a **signup** bar button.

Let's create the **IBOutlets** for this controller (**LoginViewController.h**):

```objc
@property(nonatomic, weak) IBOutlet UITextField* emailTextField;
@property(nonatomic, weak) IBOutlet UITextField* passwordTextField;
```

**emailTextField** and **passwordTextField** after being connected to the **Storyboard ViewController** are object representations of the views themselves.

Since we'll have a **login click event**, we will need a **IBAction** to run code upon button press.

```objc
-(IBAction)loginClick:(UIButton *)sender;
```

You now want to go over to the **Storyboard** and link the textfields and the loginClick: event.

On to the **LoginViewController.m**. The main interaction in this controller will be the actual login, so let's implement the **loginClick:** method.

To login we'll need to get the email and password strings from the input textfields.

```objc
 NSString* email = [self.emailTextField text];
 NSString* password = [self.passwordTextField text];
```

Since our server communicates with a **JSON** protocol (JSON is a lightweight format to transmit data from a server to an application - web, mobile,etc), we will want to send the user information (and any other information) in a previously defined JSON hierarchy.

Yesterday we developed a server in **Ruby on Rails** where an **API** was defined. One of the created endpoints was for the login interaction, where it receives a JSON object such as:

```json
{
	"user":{	
		"email": "email@exemplo.com",
		"password": "password"
	}
}
```

And returns user information and token in case of success, or a error message in case the login was unsucessful.

In Objective-C, the closest representation of a JSON is a chain of both **NSDictionary** and **NSArray** with **NSString** and **NSNumber** as values. 

```objc
NSDictionary* userDictionary = @{@"email": email,
                                 @"password": password};
NSDictionary* jsonDictionary = @{@"user":userDictionary};
```

We have now reached a stage where we actually need to communicate with the server. So let's make an interlude.

### Interlude - External Frameworks

#### Cocoapods

>To install cocoapods run **sudo gem install cocoapods** (might take a while).

If you have **cocoapods** installed on your **Mac** you can easily import any kind of framework.
Open up your **Terminal.app**, go to the project's folder and run **vi Podfile**.

Let's add a few popular frameworks to try it out:

```
platform :ios, '7.0'
pod "AFNetworking"
pod "SDWebImage"
pod "SVProgressHUD"
```

Press **Ctrl-c** (or **Esc**) and write **:wq** to Write-Quit the file. 

Next step is to actually download and install the libraries onto our project, so lets run **pod install** (this might take a few minutes depending on the network).

After it is finished you should close your **Xcode** window (Cmd-W), and open the new **Workspace** by running **open Todo.xcworkspace** on the console.

You will now have access to the downloaded libraries by using the **#import** macro in your code (e.g. #import <AFNetworking/AFNetworking.h>).

#### Without cocoapods

Go to the github pages of each framework, **download as zip** or **clone**, and drag the <name of framework> folder into your project.

To import the libraries on your .h/.m files you will have to import with #import "AFNetworking.h" since it is code on your actual project.

#### [AFNetworking](https://github.com/AFNetworking/AFNetworking)
This framework allows very easy intergration with any **RESTful** service API, whilst having a performance boost versus the Apple networking framework. This framework also has a much easier callback interface (through **blocks**).

#### [SDWebImage](https://github.com/rs/SDWebImage)
This framework is the holy grail of image downloading. It allows with close to no effort the downloading and displaying of images in **UIImageViews**. Automatically managing cache and memory consumption, allowing easy to use animation upon image visualization, etc. (Might not have enough time to go through SDWebImage on this workshop).

#### [SVProgressHUD](https://github.com/samvermette/SVProgressHUD)
This framework provides an easy way to display a loader on the screen, and also error and success messages to the user. With a very easy to use interface as well.

### End of Interlude

The easiest way to communicate with any web-server at the moment is by taking advantage of the **AFNetworking** library (see AFNetworking on the external libraries chapter).

AFNetworking Framework automatically translates this structure into a JSON string to send to the server. 

So lets perform a request to the actual server.

```objc
[[AFHTTPRequestOperationManager manager] POST:@"http://ios-todo.herokuapp.com/v1/users/sign_in.json"
                                  parameters:jsonDictionary
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       	 [self loginSuccessfulWithUserToken:[responseObject objectForKey:@"authentication_token"]];
                                     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           [self loginFailed];
                                       }];
```

This will pass the **jsonDictionary** as parameter of the **POST** to the server. It will also perform the **loginSuccessfulWithUserToken:** method with the **authentication_token** from the response JSON sent by the server. It might also call **loginFailed** in case the server did not accept our input for email/password.

>The ^(AFHTTPRequestOperation *operation, id responseObject) { code } nomenculature represent **Blocks** which are basically functions that can be passed as arguments to other functions (methods), and executed when the receiver choses to.

To provide a better experience to the user, we should also send notice that we're performing a background task between the app and the server. Let's take advantage of **SVProgressHUD** to display a simple loader with a message.

```objc
[SVProgressHUD showProgress:-1 status:@"Logging in..."];
```
Easy peazy.

We now have to define the methods used above for handling success and failed responses from the server.

```objc
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
```

In case of a failed login we reset the **userToken** and show an error message to the user using the **SVProgressHUD**.

As the code commentary suggest, in case of success, we're saving the user token onto the **LoginViewController** itself, dismissing the **SVProgressHUD** loader and performing a **segue** to go to the **TodoViewController**.

In order to save the **userToken** we'll need to create a new **Private** property to the **LoginViewController.m** above the **@implementation LoginViewController**.

```objc
@interface LoginViewController ()

@property(nonatomic,strong) NSString* userToken;

@end
```

This is the way you can add **private properties** to your classes in Objective-c. As you can see, this is an interface that is declared in your implementation file with a similar syntax, making it your private interface.

As for what a **Segue** is, it is a way to interact between different **UIViewControllers**, by reusing certain flow between them. A segue has an **identifier** to be able to perform it by code. 

Since we need to pass the obtained user token to the new TodoViewController, we'll also need to intercept the **Segue** call to set the variable on the next screen (avoiding the use of a global variable throughout the app).

>\#import "TodoViewController"

```objc
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier]isEqualToString:@"todoSegue"]){
        
        // Set the user token on the next screen
        TodoViewController* todoViewController = [segue destinationViewController];
        todoViewController.userToken = self.userToken;
    }
}
```

Finally, if we want to add a touch of proper User Experience we should also set the chain of **firstResponders** for the textfields, so that you jump between the textfields as if it was a form. (and also performing the form action when there is no next field).

```objc
// Go to next textfield upon clicking the return key (perform action if no other textfield)
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.emailTextField)
        [self.passwordTextField becomeFirstResponder];
    if(textField == self.passwordTextField)
        [self loginClick:nil];
    return YES;
}
```
The **LoginViewController** is now complete, let's go on.

## Step 5 - Signup View Controller

The process on the **SignupViewController** is very similar to the **LoginViewController**, so I will skip that particular view controller and focus on the **TodoViewController**

## Step 6 - Todo View Controller

On the **TodoViewController.m** we want to have a private property to keep the Model (Tasks) array. So let's add the next few lines of code above **@implementation TodoViewController**

```objc
@interface TodoViewController ()

@property(nonatomic,strong) NSArray* tasksArray;

@end
```



Next, since the **TodoViewController** is a **UITableViewController** and the data comes from the network, we want to add a **UIRefreshControl** to have a pull to refresh functionality. We also want to initialize the property declared above to avoid **nil** pointers. Let's add the folllowing code to the **viewDidLoad:** method.

```objc
 	// Initialize tasks array
    self.tasksArray = [NSArray new];
    
    // Create a pull to refresh
    UIRefreshControl* pullToRefresh = [[UIRefreshControl alloc]init];
    self.refreshControl = pullToRefresh;
    [pullToRefresh addTarget:self action:@selector(tasksFromServer) forControlEvents:UIControlEventValueChanged];
```

Since we want to be able to add tasks later on, let's also refresh the data everytime the **TodoViewController** is shown, by adding the following code to the **viewWillAppear:** method

```
	// Load the tasks from the server every time the controller is shown
    [self tasksFromServer];

```
On the storyboard we have a **Logout** button for the user to logout of the application. Since we're using a **UINavigationController** we are able to jump back to the first screen (**LoginViewController**) by adding the following code to the **logoutClick:** method, therefor logging out of the application.

```objc
// Go to the login screen upon logout
    [self.navigationController popToRootViewControllerAnimated:YES];
```

The **UINavigationController** allow a 'push-pop' navigation style in your app, keeping the user allways in context: If you pushed a view controller, the user will see a back arrow and automatically know that he will be able to pop that view controller, getting back to the previous state.
iOS allows multiple types of navigation and since iOS7 you can also do any type of navigation have your custom transitions. 

Now that the **TodoViewController** basic setup is done, we'll need the data from the **server**. We'll create a method named **tasksFromServer** where we'll perform a network request using **AFNetworking**.

```objc
	// Show the loader
    [SVProgressHUD showProgress:-1 status:@"Loading tasks..."];
    
    // Create JSON
    NSDictionary* jsonDictionary = @{@"authentication_token": self.userToken};
    
    // GET Tasks from Server
    [[AFHTTPRequestOperationManager manager] GET:@"http://ios-todo.herokuapp.com/v1/tasks.json"
                                       parameters:jsonDictionary
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              [self tasksSuccessfulWithJSON:responseObject];
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [self tasksFailed];
                                          }];
```

This will then show a loader, create a **JSON** and send that JSON to the endpoint **/v1/tasks.json**. Performing the **tasksSuccessfulWithJSON:** in case of success or **tasksFailed** in case something went wrong.

To implement the behavior for the server's response we need to:

```objc
-(void)tasksSuccessfulWithJSON:(NSArray*)jsonArray{
    // Dismiss the loader
    [SVProgressHUD dismiss];
    [self.refreshControl endRefreshing];
    
    // Create a mutable array to add the tasks
    NSMutableArray* tasksMutableArray = [NSMutableArray new];
    
    // Iterate every task in the task array
    for(NSDictionary* taskDictionary in jsonArray){
        
        // Create the task from the json
        Task* task = [[Task alloc]initWithIdentifier:[taskDictionary objectForKey:@"id"]
                                           withTitle:[taskDictionary objectForKey:@"title"]
                                           isDone:[[taskDictionary objectForKey:@"completed"]boolValue]];
        
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
    [self.refreshControl endRefreshing];
    
    // reset the tasks model array
    self.tasksArray = [NSArray new];
    
    // reload the tableview
    [self.tableView reloadData];
}
```

So now we have the **Task** data stored on the **self.tasksArray** object. Let's present such data in our **UITableView**.

```objc
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
    }
    
    // Get the task from the model array
    Task* task = [self.tasksArray objectAtIndex:indexPath.row];
    
    // Set the text on the textlabel
    cell.textLabel.text = task.title;
    
    // If it is done set the icon accordingly (using SDWebImage to get image from the web)
    if([task isDone])
        [cell.imageView setImage:[UIImage imageNamed:@"check"]];
    else
        [cell.imageView setImage:[UIImage imageNamed:@"clock"]];
    
    // Return the cell
    return cell;
}
```
These methods have specific names and these names are conventions given by the **UITableViewDelegate** and by the **UITableViewDataSource**. Each of these methods will be called in the table view 'lifecycle' expecting you to handle the logic that responds to actions on the table view (delegate) and that populate that table view (datasource).
This relies on the **protocol** feature of Objective-C.
In this case, since we are inheriting from **UITableViewController**, both protocols came already implemented by the superclass, but if we wanted to implement these protocols in a **UIViewController** the syntax would look a lot like C++ templates:

```objc
@interface LoginViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
```

The **numberOfRowsInSection:** needs to return the number of elements to be shown on the **UITableView**, it may be sectioned but this is not the case as we only need 1 actual section.

For the **cellForRowAtIndexPath:** we must return a **UITableViewCell** representing the data we want, in this case a **Task** object. To avoid performance issues all cells should be reused as much as possible, therefore we only create a cell in case we cannot get any reusable cells from the **UITableView**. We then assign the title to the cell's text label and set the cell's imageview to an image representing the task's state.
As you could see, **indexPath** is a structure/class that gives us the actual row, but you could also find the section **indexPath.section**.

Since we're using the two images **check** and **clock** we need to add them to the application. Go to the [GitHub](http://github.com/ivanbruel/todoapp) and download the four **.png** files and drag them to your Image.xcassets, they will add 2 images containing a normal and a @2x version.

These images may be used by calling the **[UIImage imageNamed:]** method by passing the image name as a string.
The UIImage class is an object representation of an actual image file/data.

A **UITableViewCell** by default contains a **UILabel** (object representation of a label) named **textLabel** and a **UIImageView** named **imageView**, these properties may be accessed by calling **cell.imageView** or **cell.textLabel**.

To add a little bit more complexity to the application we need to be able to switch between task state, so lets add that logic to the **didSelectRowAtIndexPath:** method of the **UITableViewController**.

```objc
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Task for selected cell
    Task* task = [self.tasksArray objectAtIndex:indexPath.row];
    
    // Switch task status
    [self task:task markAsDone:![task isDone]];
}
```

This will run the **task:markAsDone:** method for the selected task. Let's implement such method now:

```objc
-(void)task:(Task*)task markAsDone:(BOOL)done{
    // Show the loader
    [SVProgressHUD showProgress:-1];
    
    // Create JSON
    NSDictionary* taskDictionary = @{@"completed": [NSNumber numberWithBool:done]};
    NSDictionary* jsonDictionary = @{@"authentication_token": self.userToken,
                                     @"task":taskDictionary};
    
    // GET Tasks from Server
    [[AFHTTPRequestOperationManager manager] PUT:[NSString stringWithFormat:@"http://ios-todo.herokuapp.com/v1/tasks/%d.json",task.identifier.intValue]
                                       parameters:jsonDictionary
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              [self taskMarkSuccesfulWithTask:task isDone:done];
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [self taskMarkFailed];
                                          }];
}
```

This method will, again, create a **JSON** and send it to the endpoint with a PUT method, where it will update the status of the task on the server side. In case of success it will run the **taskMarkSucessfulWithTask:** method, otherwise it will fall back to the **taskMarkFailed** method.

These two methods are implemented this way: 

```objc
-(void)taskMarkSuccesfulWithTask:(Task*)task isDone:(BOOL)done{
    task.isDone = done;
    // dismiss the loader
    [SVProgressHUD dismiss];
        
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
```

In the first method, `-(void)taskMarkSuccesfulWithTask:(Task*)task isDone:(BOOL)done` we mark the task as done, which can be false.
We dismiss the **SVProgressHUD** again and deselect the selected cell, as it is not needed anymore, and then call **reloadData**, which will force the table view to check for updates in its data (and it will probably call all the **dataSource** methods implemented above.)

In the second method, we simply dismiss the **SVProgressHUD** and deselect the row, cause in failure, the app model won't change its state.

## Step 7 - New Task View Controller

The process on the **NewTaskViewController** is very similar to the **LoginViewController** and the **SignupViewController**, so I will skip that particular view controller as well.

## Prologue

Hopefully if this workshop went according to plan you've learned a bit of everything in regards to Objective-C, iOS, MVC, Storyboards, View Controllers, External Frameworks, etc.

If you want to learn a bit more about Objective-C and iOS development I suggest you look into:

- Begginers:
	- [Developing iOS 7 Apps for iPhone and iPad by Stanford @ iTunes University](https://itunes.apple.com/us/course/developing-ios-7-apps-for/id733644550)
	- [Ray Wenderlich - Tutorials for Developers & Gamers](http://www.raywenderlich.com/)
	- [Objective-C coding style guide](https://github.com/raywenderlich/objective-c-style-guide)
- Experienced:
	- [NSHipster](http://nshipster.com/)
- Plug-and-Play free-to-use views:
	- [CocoaControls](http://cocoacontrols.com)
- Good-to-Perfect UI/UX examples
	- [Pttrns](http://pttrns.com)

Hot tecnologies to work with:

- CoreData
- AFNetworking
- UIView animations
- CALayers
- UIGestureRecognizers
- SDWebImage

Feel free to contact me in case you need help, advice or guidance, my contacts are:

- Email: ibruel@faber-ventures.com
- Twitter: [@ivanbruel](https://twitter.com/ivanbruel)
- Github: [/ivanbruel](https://github.com/ivanbruel/todoapp)
