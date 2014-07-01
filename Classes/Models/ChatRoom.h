//
//  ChatRoom.h
//  Ultra meetup
//
//  Created by Filip Beć on 01/07/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>

#import "Group.h"

@interface ChatRoom : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic, retain) Group *group1;
@property (nonatomic, retain) Group *group2;

@end
