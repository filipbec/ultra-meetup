//
//  PhotosTableViewCell.m
//  Ultra meetup
//
//  Created by Filip Beć on 25/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "PhotosTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PhotosTableViewCell

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
    self.photo1.layer.cornerRadius = 4;
    self.photo1.layer.masksToBounds = YES;
    
    self.photo2.layer.cornerRadius = 4;
    self.photo2.layer.masksToBounds = YES;
    
    self.photo3.layer.cornerRadius = 4;
    self.photo3.layer.masksToBounds = YES;
    
    self.photo4.layer.cornerRadius = 4;
    self.photo4.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
