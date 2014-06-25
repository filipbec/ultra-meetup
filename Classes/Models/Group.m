//
//  Group.m
//  Ultra meetup
//
//  Created by Vedran Burojevic on 6/25/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "Group.h"

@implementation Group

- (instancetype)initWithGroupID:(NSString *)groupID
                        country:(NSString *)country
               groupDescription:(NSString *)groupDescription
                         gender:(NSInteger)gender
                        members:(NSArray *)members
                         photos:(NSArray *)photos
                    likedGroups:(NSArray *)likedGroups
                 dislikedGroups:(NSArray *)dislikedGroups
{
    self = [super init];
    if (self) {
        self.groupID = groupID;
        self.country = country;
        self.groupDescription = groupDescription;
        self.gender =  gender;
        self.members = members;
        self.photos = photos;
        self.likedGroups = likedGroups;
        self.dislikedGroups = dislikedGroups;
    }
    return self;
}

@end