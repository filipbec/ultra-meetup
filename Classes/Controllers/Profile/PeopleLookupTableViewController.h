//
//  PeopleLookupTableViewController.h
//  Ultra meetup
//
//  Created by Filip Beć on 21/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PeopleLookupTableViewController;

@protocol PeopleLookupDelegate <NSObject>

- (void)peopleLookupController:(PeopleLookupTableViewController *)controller didSelectFriend:(PFUser *)user;

@end

@interface PeopleLookupTableViewController : UITableViewController <UIAlertViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, assign) id<PeopleLookupDelegate> delegate;

@end
