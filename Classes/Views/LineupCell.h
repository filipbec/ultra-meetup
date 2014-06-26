//
//  LineupCell.h
//  Ultra meetup
//
//  Created by Vedran Burojevic on 6/26/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineupCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;

@end
