//
//  PFUser+Equal.m
//  Ultra meetup
//
//  Created by Filip Beć on 30/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "PFUser+Equal.h"

@implementation PFUser (Equal)

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[PFUser class]]) {
        return NO;
    }
    
    PFUser *other = (PFUser *)object;
    return [self.objectId isEqualToString:other.objectId];
}

- (NSUInteger)hash
{
    return [self.objectId hash];
}

@end
