//
//  App.h
//  Ultra meetup
//
//  Created by Filip Beć on 27/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Group.h"

@interface App : NSObject

+ (App*)sharedInstance;
+ (App*)instance;

@property (nonatomic, retain) Group *myGroup;

@end
