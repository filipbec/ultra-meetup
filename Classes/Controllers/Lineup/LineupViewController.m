//
//  LineupViewController.m
//  Ultra meetup
//
//  Created by Filip Beć on 21/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "LineupViewController.h"
#import "LineupCell.h"
#import "LineupTableSectionView.h"

typedef NS_ENUM(NSInteger, Day) {
    Day1 = 1,
    Day2 = 2,
    Day3 = 3
};

@interface LineupViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *topBarButtons;
@property (weak, nonatomic) IBOutlet UIView *activeButtonIndicatorView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *lineupMainArray;
@property (strong, nonatomic) NSArray *lineupArenaArray;
@property (strong, nonatomic) NSArray *lineupRadioArray;

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
    [self refreshTableViewWithDay:1];
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
    
    // Active button indicator
    self.activeButtonIndicatorView.backgroundColor = PURPLE_COLOR;
    
    // Table view
    CGFloat dummyViewHeight = 60.0;
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, dummyViewHeight)];
    self.tableView.tableHeaderView = dummyView;
    self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0);
}

- (void)refreshTableViewWithDay:(NSInteger)dayNumber
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Day%ld", (long)dayNumber] ofType:@"plist"];
    NSDictionary *lineup = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    self.lineupMainArray = lineup[@"Main"];
    self.lineupArenaArray = lineup[@"Arena"];
    self.lineupRadioArray = lineup[@"Radio"];
    
    [self.tableView reloadData];
}

#pragma mark - Button action

- (IBAction)dayButtonActionHandler:(UIButton *)sender
{
    for (UIButton *button in self.topBarButtons) {
        if ([button isEqual:sender]) {
            [button setSelected:YES];
        } else {
            [button setSelected:NO];
        }
    }
    
    CGRect newActiveButtonIndicatorViewFrame = self.activeButtonIndicatorView.frame;
    newActiveButtonIndicatorViewFrame.origin.x = sender.frame.origin.x;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.activeButtonIndicatorView.frame = newActiveButtonIndicatorViewFrame;
    }];
    
    Day day = sender.tag;
    [self refreshTableViewWithDay:day];
}

#pragma mark - Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LineupTableSectionView" owner:self options:nil];
    LineupTableSectionView *lineupTableSectionView = topLevelObjects[0];
    
    switch (section) {
        case 0:
            lineupTableSectionView.titleLabel.text = @"MAIN STAGE";
            break;
            
        case 1:
            lineupTableSectionView.titleLabel.text = @"ULTRA WORLDWIDE ARENA";
            break;
            
        case 2:
            lineupTableSectionView.titleLabel.text = @"UMF RADIO";
            break;
            
        default:
            break;
    }
    
    return lineupTableSectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self.lineupMainArray count];
            break;
            
        case 1:
            return [self.lineupArenaArray count];
            break;
            
        case 2:
            return [self.lineupRadioArray count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LineupCell";
    
    LineupCell *cell = (LineupCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSDictionary *eventDictionary = nil;
    
    switch (indexPath.section) {
        case 0:
            eventDictionary = self.lineupMainArray[indexPath.row];
            break;
            
        case 1:
            eventDictionary = self.lineupArenaArray[indexPath.row];
            break;
            
        case 2:
            eventDictionary = self.lineupRadioArray[indexPath.row];
            break;
            
        default:
            break;
    }
    
    cell.timeLabel.text = eventDictionary[@"Time"];
    cell.artistLabel.text = eventDictionary[@"Artist"];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
