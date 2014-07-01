//
//  GroupDetailsViewController.h
//  Ultra meetup
//
//  Created by Vedran Burojevic on 7/1/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Group;

@interface GroupDetailsViewController : UITableViewController

@property (nonatomic, strong) Group *group;

@end
