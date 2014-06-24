//
//  PeopleLookupTableViewController.m
//  Ultra meetup
//
//  Created by Filip Beć on 21/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "PeopleLookupTableViewController.h"

#define LOADING_ERROR_ALERT_TAG     12345
#define kInviteFacebookFriendsAlert 54343

@interface PeopleLookupTableViewController ()

@property (nonatomic, retain) NSArray *friends;
@property (nonatomic, retain) NSArray *searchResults;

@end

@implementation PeopleLookupTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadFacebookFriends];
#ifdef DEBUG
//    self.friends = [FacebookFriend fakeArray];
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button action handler

- (IBAction)closeButtonActionHandler:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResults.count;
    }
    
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeopleLookupCell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PeopleLookupCell"];
    }
    
    FacebookFriend *friend = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        friend = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        friend = [self.friends objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    cell.textLabel.textColor = [UIColor colorWithRed:30./255 green:30./255 blue:30./255 alpha:1.0];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FacebookFriend *friend = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        friend = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        friend = [self.friends objectAtIndex:indexPath.row];
    }
    
    [self.delegate peopleLookupController:self didSelectFacebookFriend:friend];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Loading friends

- (void)loadFacebookFriends
{
    FBRequest *request = [FBRequest requestForMyFriends];
    
    // SHOW LOADING
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // HIDE LOADING
        
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendResults = [result objectForKey:@"data"];
            NSMutableArray *array = [[NSMutableArray alloc] init];

            for (NSDictionary *dict in friendResults) {
                FacebookFriend *friend = [[FacebookFriend alloc] initWithDictionary:dict];
                [array addObject:friend];
            }
            
            self.friends = [self sortedFriendsArray:array];
            if (self.friends.count == 0) {
                [self showInviteFriendsMessage];
            }
            
            [self.tableView reloadData];

        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try again", nil];
            alert.tag = LOADING_ERROR_ALERT_TAG;
            [alert show];
        }
    }];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == LOADING_ERROR_ALERT_TAG && buttonIndex == 1) {
        [self loadFacebookFriends];
    } else if (alertView.tag == kInviteFacebookFriendsAlert && buttonIndex == 1) {
        [self inviteFriends];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterSearchResultsWithString:searchString];
    return YES;
}

#pragma mark - Utility

- (void)filterSearchResultsWithString:(NSString *)string
{
    NSPredicate *predicate = nil;
    
    NSArray *strings = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    
    for (NSString *searchString in strings) {
        if (searchString.length > 0) {
            NSPredicate *subpredicate = [NSPredicate predicateWithFormat:@"((firstName BEGINSWITH[cd] %@) OR (lastName BEGINSWITH[cd] %@) OR (name BEGINSWITH[cd] %@))", searchString, searchString, searchString, searchString];
            [predicates addObject:subpredicate];
        }
    }
    predicate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:predicates];
    
    self.searchResults = [self.friends filteredArrayUsingPredicate:predicate];
    self.searchResults = [self sortedFriendsArray:self.searchResults];
}

- (NSArray *)sortedFriendsArray:(NSArray *)array
{
    NSSortDescriptor *d1 = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *d2 = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    return [array sortedArrayUsingDescriptors:@[d1, d2]];
}


#pragma mark - Invite

- (void)showInviteFriendsMessage
{
#warning TODO
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ultra meetup" message:@"PORUKA!!!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Invite friends", nil];
    alert.tag = kInviteFacebookFriendsAlert;
    [alert show];
}

- (void)inviteFriends
{
    if ([[FBSession activeSession] isOpen]) {
        [FBWebDialogs presentRequestsDialogModallyWithSession:[PFFacebookUtils session] message:@"Instaliraj aplikaciju Ultra meetup!" title:@"BOK!" parameters:nil handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
             if (error) {
                 NSLog(@"ERROR: %@", error);
             } else {
                 
                 if (result == FBWebDialogResultDialogNotCompleted) {
                     NSLog(@"Error");
                 } else if([[resultURL description] hasPrefix:@"fbconnect://success?request="]) {
                     // Facebook returns FBWebDialogResultDialogCompleted even user
                     // presses "Cancel" button, so we differentiate it on the basis of
                     // url value, since it returns "Request" when we ACTUALLY
                     // completes Dialog
                     
//                     [self requestSucceeded];
                 } else {
                     // User Cancelled the dialog
//                     [self requestFailedWithError:nil];
                 }
             }
         }];
    }
}

@end
