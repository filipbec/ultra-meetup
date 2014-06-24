//
//  LineupViewController.m
//  Ultra meetup
//
//  Created by Filip Beć on 21/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "LineupViewController.h"

typedef NS_ENUM(NSInteger, Day) {
    Day1 = 1,
    Day2 = 2,
    Day3 = 3
};

@interface LineupViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *topBarButtons;

@end


@implementation LineupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

- (void)setupViews
{
    for (UIButton *button in self.topBarButtons) {
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.numberOfLines = 0;
        
        NSString *dayString = nil;
        NSString *dateString = nil;
        
        switch (button.tag) {
            case Day1:
                dayString = @"Friday";
                dateString = @"11.07.";
                break;

            case Day2:
                dayString = @"Saturday";
                dateString = @"12.07.";
                break;
                
            case Day3:
                dayString = @"Sunday";
                dateString = @"13.07.";
                break;
            default:
                break;
        }
        
        NSString *fullString = [NSString stringWithFormat:@"%@\n%@", dayString, dateString];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:fullString];
        
        [string addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12]
                       range:NSMakeRange(0, dayString.length)];
        
        [string addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]
                       range:NSMakeRange(dayString.length, fullString.length - dayString.length)];
        
        NSMutableAttributedString *selectedString = [[NSMutableAttributedString alloc] initWithAttributedString:string];
        
        [string addAttribute:NSForegroundColorAttributeName
                       value:[UIColor colorWithRed:30./255 green:30./255 blue:30./255 alpha:1.0]
                       range:NSMakeRange(0, fullString.length)];
        
        [selectedString addAttribute:NSForegroundColorAttributeName
                               value:PURPLE_COLOR
                               range:NSMakeRange(0, fullString.length)];
        
        [button setAttributedTitle:string forState:UIControlStateNormal];
        [button setAttributedTitle:selectedString forState:UIControlStateHighlighted];
        [button setAttributedTitle:selectedString forState:UIControlStateSelected];
    }
}

#pragma mark - Button action

- (IBAction)dayButtonActionHandler:(id)sender
{
    for (UIButton *button in self.topBarButtons) {
        if ([button isEqual:sender]) {
            [button setSelected:YES];
        } else {
            [button setSelected:NO];
        }
    }
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
