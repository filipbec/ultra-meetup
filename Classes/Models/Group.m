//
//  Group.m
//  Ultra meetup
//
//  Created by Vedran Burojevic on 6/25/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "Group.h"

@implementation Group

@dynamic country;
@dynamic gender;
@dynamic images;
@dynamic users;
@dynamic dislikedBy;
@dynamic likedBy;
@dynamic groupDescription;

+ (NSString *)parseClassName
{
    return @"Group";
}

@end