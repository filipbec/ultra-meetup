//
//  MapLocation.h
//  Ultra meetup
//
//  Created by Filip Beć on 20/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapLocation : NSObject <MKAnnotation>

/// Default coordinate - Spaladium Arena: 3.5242968, 16.4342238
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
