//
//  GroupDetailsViewController.h
//  Ultra meetup
//
//  Created by Vedran Burojevic on 7/1/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GroupDetailsViewControllerDelegate <NSObject>

- (void)groupDetailsViewControllerDidLikeGroup;
- (void)groupDetailsViewControllerDidDislikeGroup;

@end

@class Group;

@interface GroupDetailsViewController : UITableViewController

@property (nonatomic, weak) id <GroupDetailsViewControllerDelegate> delegate;
@property (nonatomic, strong) Group *group;

@end
