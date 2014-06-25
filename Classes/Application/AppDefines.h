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

// ParseChat

//-------------------------------------------------------------------------------------------------------------------------------------------------
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]

//-------------------------------------------------------------------------------------------------------------------------------------------------
#define		PF_USER_CLASS_NAME				@"_User"
#define		PF_USER_USERNAME				@"username"
#define		PF_USER_PASSWORD				@"password"
#define		PF_USER_EMAIL					@"email"
#define		PF_USER_PICTURE					@"picture"
#define		PF_USER_THUMBNAIL				@"thumbnail"

#define		PF_CHAT_CLASS_NAME				@"Chat"
#define		PF_CHAT_ROOM					@"room"
#define		PF_CHAT_USER					@"user"
#define		PF_CHAT_TEXT					@"text"
#define		PF_CHAT_CREATEDAT				@"createdAt"

#define		PF_CHATROOMS_CLASS_NAME			@"ChatRooms"
#define		PF_CHATROOMS_ROOM				@"room"