//
//  SimpleInputTableViewCell.h
//  Ultra meetup
//
//  Created by Filip Beć on 25/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleInputTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
