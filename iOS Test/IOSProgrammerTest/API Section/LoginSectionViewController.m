//
//  APISectionViewController.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "LoginSectionViewController.h"
#import "MainMenuViewController.h"


@interface LoginSectionViewController () <UIAlertViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;



@end

@implementation LoginSectionViewController

//API URL and containers for the username and password
#define loginURLString @"http://dev.apppartner.com/AppPartnerProgrammerTest/scripts/login.php"
NSString *username = @"";
NSString *password = @"";


- (void)viewDidLoad
{
    [super viewDidLoad];
    // setting up some appearance details
    [self changeBorderColor:self.passwordTextField];
    [self changeBorderColor:self.usernameTextField];
    self.passwordTextField.secureTextEntry = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
    //Tap gesture recognizer to dismiss the keyboard on tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer: tap];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Buttons

- (IBAction)backAction:(id)sender
{
    MainMenuViewController *mainMenuViewController = [[MainMenuViewController alloc] init];
    [self.navigationController pushViewController:mainMenuViewController animated:YES];
}

- (IBAction)loginTapped:(id)sender {
    //collecting username and password
    username = [self.usernameTextField text];
    password = [self.passwordTextField text];
    
    //sending an alert in case one of the fields is empty
    if( [username isEqual: @""] || [password isEqual: @""])
    {
        UIAlertView *alertEmpty = [[UIAlertView alloc] initWithTitle:(@"Invalid!") message:(@"Please enter both Username and Password.")  delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alertEmpty show];

    }else{
        //call the loginToServer method
        [self loginToServer];
        }
}

#pragma mark -
#pragma mark Login To Server

-(void)loginToServer
{
    //if inputs are entered, send a POST request to AppPartner login URL
    NSURL *url = [NSURL URLWithString: loginURLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    
    //POST string here with the entered username and password
    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@", username, password];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //setting up the request headers and body
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    //a queue to regulate the execution of the request
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    
    //A UIAlert that displays a WAIT WHILE CONNECTION IS MADE message
    UIAlertView *alertConnect = [[UIAlertView alloc] initWithTitle:(@"Connecting")
                                                           message:(@"Please wait...")
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:nil];
    [alertConnect show];
    
    //getting the time before we send the request (to use it later to get the request's duration
    NSDate *beginTime = [NSDate date];
    //an asynchronous request with a completion handler
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         
         // a dispatch to release resources as soon as we get a response
         dispatch_async(dispatch_get_main_queue(), ^(void){
             
             //close the "waiting alert" when a response is received or a time out is signaled
             [alertConnect dismissWithClickedButtonIndex:0 animated:YES];
             
             
             if (error)
                 
             {
                 
                 //in case there is an error with the request or the response
                 //save the error message to display it on the alertview
                 NSString *errorMessage = [error localizedDescription];
                 UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:(@"Error!")
                                                                      message:([NSString stringWithFormat:@"%@", errorMessage])
                                                                     delegate:self
                                                            cancelButtonTitle:@"Close"
                                                            otherButtonTitles:nil];
                 [alertError show];
                
                
                 
             }
             else
             {
                 //if no error, we need to save the time it took to complete the request
                 NSTimeInterval requestDuration = -[beginTime timeIntervalSinceNow];
                 NSLog(@"%f", requestDuration);
                 
                 //just a display on the log of the data received
                 NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
                 
                 //in case there is an error during Deserialization
                 NSError *errorJSON;
                 
                 //Deserialization
                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorJSON];
                 
                 if (errorJSON) {
                     //In case the server sends corrupt data (in this case we know it won't but it's always good to be prepared for it. The user will never have to see this message if everything is fine on the back-end)
                     UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:(@"Error")
                                                                          message:(@"There was a problem with the response")
                                                                         delegate:self
                                                                cancelButtonTitle:@"Close"
                                                                otherButtonTitles:nil];
                     [alertError show];
                 }
                 else{
                     //this is when we get the response, which could be "success" or "failure"
                     if([json[@"code"]  isEqual: @"Success"]){
                         
                         //in case it's a success, display the code, the message and the time it took in a UIAlert
                         UIAlertView *alertSuccess = [[UIAlertView alloc] initWithTitle:([NSString stringWithFormat:@"%@", json[@"code"]])
                                                                                message:([NSString stringWithFormat:@"%@\n%0.2f milliseconds", json[@"message"], requestDuration*1000])
                                                                               delegate:self
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                         [alertSuccess show];
                         
                         
                     }
                     else{
                         
                         //otherwise just display whatever the code and error message are
                         UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:([NSString stringWithFormat:@"%@", json[@"code"]])
                                                                              message:([NSString stringWithFormat:@"%@", json[@"message"]])
                                                                             delegate:self
                                                                    cancelButtonTitle:@"Close"
                                                                    otherButtonTitles:nil];
                         [alertError show];
                         
                         
                     }
                 }
             }
         });
     }];

}


#pragma mark -
#pragma mark UITextField Appearance

// one way of guetting the TextFields have the desired look. there are other ways but this is a quick solution
-(void)changeBorderColor:(UITextField *)textField
{
    textField.layer.borderColor = [UIColor whiteColor].CGColor;
    textField.layer.borderWidth = 2;
    textField.layer.masksToBounds = YES;
}

//Hiding the keyboard when the view is tapped
-(void)hideKeyboard{
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
}

#pragma mark -
#pragma mark Delegates
// a delegate that handles the switch to the Main Menu Screen. Again, there are multiple ways to get this result
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([[alertView buttonTitleAtIndex:buttonIndex]  isEqual: @"OK"]){
        MainMenuViewController *mainMenuViewController = [[MainMenuViewController alloc] init];
        [self.navigationController pushViewController:mainMenuViewController animated:YES];
    }
    else{
        
    }
}






@end
