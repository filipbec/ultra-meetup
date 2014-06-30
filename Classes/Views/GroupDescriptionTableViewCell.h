//
//  GroupDescriptionTableViewCell.h
//  Ultra meetup
//
//  Created by Filip Beć on 30/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "SimpleInputTableViewCell.h"

UIKIT_EXTERN NSString *const GroupDescriptionCellIdentifier;

@interface GroupDescriptionTableViewCell : SimpleInputTableViewCell

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
