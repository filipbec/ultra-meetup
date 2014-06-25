//
//  Group.h
//  Ultra meetup
//
//  Created by Vedran Burojevic on 6/25/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject

@property (nonatomic, copy) NSString *groupID;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *groupDescription;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSArray *likedGroups;
@property (nonatomic, strong) NSArray *dislikedGroups;

- (instancetype)initWithGroupID:(NSString *)groupID
                        country: (NSString *)country
               groupDescription: (NSString *)groupDescription
                         gender: (NSInteger)gender
                        members: (NSArray *)members
                         photos: (NSArray *)photos
                    likedGroups: (NSArray *)likedGroups
                 dislikedGroups: (NSArray *)dislikedGroups;

@end
