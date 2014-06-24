//
//  MapLocation.m
//  Ultra meetup
//
//  Created by Filip Beć on 20/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "MapLocation.h"

@implementation MapLocation

- (id)init
{
    self = [super init];
    if (self) {
        self.coordinate = CLLocationCoordinate2DMake(43.5244169,16.4342308);
    }
    return self;
}

@end
