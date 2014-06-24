//
//  PeopleLookupTableViewController.h
//  Ultra meetup
//
//  Created by Filip Beć on 21/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookFriend.h"

@class PeopleLookupTableViewController;

@protocol PeopleLookupDelegate <NSObject>

- (void)peopleLookupController:(PeopleLookupTableViewController *)controller didSelectFacebookFriend:(FacebookFriend *)fbFriend;

@end

@interface PeopleLookupTableViewController : UITableViewController <UIAlertViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, assign) id<PeopleLookupDelegate> delegate;

@end
