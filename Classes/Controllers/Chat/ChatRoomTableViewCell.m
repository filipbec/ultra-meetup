//
//  ChatRoomTableViewCell.m
//  Ultra meetup
//
//  Created by Filip Beć on 01/07/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "ChatRoomTableViewCell.h"

@implementation ChatRoomTableViewCell

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
    
    self.roomImageView.layer.masksToBounds = YES;
    self.roomImageView.layer.cornerRadius = self.roomImageView.frame.size.width / 2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
