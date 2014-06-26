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

@property (nonatomic,copy) NSString *title;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)title andCoordinates:(CLLocationCoordinate2D)coordinates;

@end
