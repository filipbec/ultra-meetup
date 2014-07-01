//
//  Group.m
//  Ultra meetup
//
//  Created by Vedran Burojevic on 6/25/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "Group.h"

@implementation Group

@dynamic country;
@dynamic gender;
@dynamic images;
@dynamic users;
@dynamic dislikedBy;
@dynamic likedBy;
@dynamic groupDescription;

@dynamic fullName;

+ (NSString *)parseClassName
{
    return @"Group";
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![super isKindOfClass:[self class]]) {
        return NO;
    }
    
    Group *g = other;
    return [self.objectId isEqualToString:g.objectId];
}

- (NSUInteger)hash
{
    return [self.objectId hash];
}

- (NSString *)fullName
{
    NSString *name = @"";
    NSInteger lastIndex = [self.users count] - 1;
    NSInteger index = 0;
    
    for (PFUser *user in self.users) {
        if (index == 0) {
            name = [user objectForKey:@"firstName"];
        } else if (index == lastIndex) {
            name = [name stringByAppendingFormat:@" and %@", [user objectForKey:@"firstName"]];
        } else {
            name = [name stringByAppendingFormat:@", %@", [user objectForKey:@"firstName"]];
        }
        
        index++;
    }
    name = [name stringByAppendingFormat:@" from %@", self.country];
    
    return name;
}

@end