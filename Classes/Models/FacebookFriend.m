//
//  FacebookFriend.m
//  Ultra meetup
//
//  Created by Filip Beć on 21/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "FacebookFriend.h"

@implementation FacebookFriend

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.name = dict[@"name"];
        self.firstName = dict[@"first_name"];
        self.lastName = dict[@"last_name"];
        self.username = dict[@"username"];
        self.fbID = dict[@"id"];
    }
    return self;
}

+ (NSArray *)fakeArray
{
    FacebookFriend *f1 = [[FacebookFriend alloc] init];
    FacebookFriend *f2 = [[FacebookFriend alloc] init];
    FacebookFriend *f3 = [[FacebookFriend alloc] init];
    
    f1.name = @"Filip Beć";
    f1.firstName = @"Filip";
    f1.lastName = @"Beć";
    f1.username = @"d4red3vil";
    f1.fbID = @"12345";

    f2.name = @"Matej Špoler";
    f2.firstName = @"Matej";
    f2.lastName = @"Špoler";
    f2.username = @"matej";
    f2.fbID = @"12346";
    
    f3.name = @"Ivana Duka";
    f3.firstName = @"Ivana";
    f3.lastName = @"Duka";
    f3.username = @"ivana von teasse";
    f3.fbID = @"1234565";
    
    return @[f1, f2, f3];
}

@end
