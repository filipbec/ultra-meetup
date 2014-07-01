//
//  LoginViewController.m
//  Ultra meetup
//
//  Created by Filip Beć on 24/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "App.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Login action

- (IBAction)loginButtonActionHandler:(id)sender
{
    NSArray *permissionsArray = @[@"user_about_me"];
    
    // Login PFUser using Facebook
    [self.activityIndicator startAnimating];
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [self.activityIndicator stopAnimating];
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            
            FBRequest *request = [FBRequest requestForMe];
            // Send request to Facebook
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // result is a dictionary with the user's Facebook data
                    NSDictionary *userData = (NSDictionary *)result;
                    NSString *name = userData[@"name"];
                    NSString *firstName = userData[@"first_name"];
                    
                    PFUser *user = [PFUser currentUser];
                    [user setObject:name forKey:@"name"];
                    [user setObject:firstName forKey:@"firstName"];
                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        [self openTabBarViewController];
                    }];
                    
                    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                    [currentInstallation setObject:[PFUser currentUser] forKey:@"user"];
                    [currentInstallation saveEventually];
                }
            }];
            
        } else {
            NSLog(@"User with facebook logged in!");
            [self openTabBarViewController];
        }
    }];
}

- (void)openTabBarViewController
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UITabBarController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"TabBarVC"];
    [appDelegate.window setRootViewController:vc];
    
}

@end
