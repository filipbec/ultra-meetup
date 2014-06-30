//
//  Group.h
//  Ultra meetup
//
//  Created by Vedran Burojevic on 6/25/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/PFObject+Subclass.h>

@interface Group : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic, strong) NSString *country;
@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSArray *dislikedBy;
@property (nonatomic, strong) NSArray *likedBy;

@property (nonatomic, strong) NSString *groupDescription;

@end
