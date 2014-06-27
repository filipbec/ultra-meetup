//
//  App.m
//  Ultra meetup
//
//  Created by Filip Beć on 27/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "App.h"

@implementation App

static App *_instance;

- (id)init {
    self = [super init];
    if (self) {
        //Add your custom initialization code here
    }
    return self;
}

#pragma mark - Singleton Methods

+ (App*)sharedInstance {
	if(!_instance) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			_instance = [[self alloc] init];
        });
    }
    return _instance;
}

+ (App*)instance {
    return [self sharedInstance];
}

#pragma mark - Custom Methods

// Add your custom methods here

@end
