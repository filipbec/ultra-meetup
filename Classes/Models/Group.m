//
//  Group.m
//  Ultra meetup
//
//  Created by Vedran Burojevic on 6/25/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "Group.h"

@implementation Group

#pragma mark - Object Lifecycle

- (instancetype)initWithGroupID:(NSString *)groupID
                        country: (NSString *)country
               groupDescription: (NSString *)groupDescription
                         gender: (NSInteger)gender
                        members: (NSArray *)members
                    facebookIDs: (NSArray *)facebookIDs
                         photos: (NSArray *)photos
                    likedGroups:(NSArray *)likedGroups
                 dislikedGroups:(NSArray *)dislikedGroups
{
    self = [super init];
    if (self) {
        _groupID = groupID;
        _country = country;
        _groupDescription = groupDescription;
        _gender =  gender;
        _members = members;
        _facebookIDs = facebookIDs;
        _photos = photos;
        _likedGroups = likedGroups;
        _dislikedGroups = dislikedGroups;
    }
    return self;
}

@end