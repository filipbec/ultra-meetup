//
//  MapLocation.m
//  Ultra meetup
//
//  Created by Filip Beć on 20/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "MapLocation.h"

@implementation MapLocation

- (id)initWithTitle:(NSString *)title andCoordinates:(CLLocationCoordinate2D)coordinates
{
    self = [super init];
    if (self) {
        self.title = title;
        self.coordinate = coordinates;
    }
    return self;
}

@end
