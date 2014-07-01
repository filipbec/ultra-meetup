//
//  ChatRoom.m
//  Ultra meetup
//
//  Created by Filip Beć on 01/07/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "ChatRoom.h"

@implementation ChatRoom

@dynamic group1;
@dynamic group2;

+ (NSString *)parseClassName
{
    return @"ChatRoom";
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![super isKindOfClass:[self class]]) {
        return NO;
    }
    
    ChatRoom *room = other;
    return [self.objectId isEqualToString:room.objectId];
}

- (NSUInteger)hash
{
    return [self.objectId hash];
}

@end
