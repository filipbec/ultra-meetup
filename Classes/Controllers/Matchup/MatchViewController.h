//
//  MatchViewController.h
//  Ultra meetup
//
//  Created by Filip Beć on 01/07/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
#import "ChatRoom.h"
#import "ChatView.h"

@interface MatchViewController : UIViewController

@property (nonatomic, retain) Group *group;
@property (nonatomic, retain) ChatRoom *chatroom;

@end
