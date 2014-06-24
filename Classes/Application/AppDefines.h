//
//  AppDefines.h
//  Ultra meetup
//
//  Created by Filip Beć on 21/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#define IS_IPHONE_5		(fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < 1)
#define IS_IPHONE    	([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_IPAD      	([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define PURPLE_COLOR    [UIColor colorWithRed:156./255 green:36./255 blue:238./255 alpha:1.0]