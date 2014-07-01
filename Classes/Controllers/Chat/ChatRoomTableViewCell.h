//
//  ChatRoomTableViewCell.h
//  Ultra meetup
//
//  Created by Filip Beć on 01/07/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatRoomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *roomImageView;
@property (weak, nonatomic) IBOutlet UILabel *roomTitleLabel;

@end
