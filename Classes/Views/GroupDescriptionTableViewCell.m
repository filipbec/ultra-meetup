//
//  GroupDescriptionTableViewCell.m
//  Ultra meetup
//
//  Created by Filip Beć on 30/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "GroupDescriptionTableViewCell.h"

NSString *const GroupDescriptionCellIdentifier = @"DescriptionCell";

@implementation GroupDescriptionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
