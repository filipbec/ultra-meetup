//
//  FacebookFriend.h
//  Ultra meetup
//
//  Created by Filip Beć on 21/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookFriend : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *fbID;

- (id)initWithDictionary:(NSDictionary *)dict;
+ (NSArray *)fakeArray;

@end
