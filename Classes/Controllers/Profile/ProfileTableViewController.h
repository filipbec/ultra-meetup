//
//  ProfileTableViewController.h
//  Ultra meetup
//
//  Created by Filip Beć on 21/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeopleLookupTableViewController.h"
#import "Group.h"

@interface ProfileTableViewController : UITableViewController <PeopleLookupDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, retain) Group *group;

@end
