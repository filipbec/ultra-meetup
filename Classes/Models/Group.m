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
{
    self = [super init];
    if (self) {
        self.groupID = groupID;
        self.country = country;
        self.groupDescription = groupDescription;
        self.gender =  gender;
        self.members = members;
        self.photos = photos;
    }
    return self;
}

@end