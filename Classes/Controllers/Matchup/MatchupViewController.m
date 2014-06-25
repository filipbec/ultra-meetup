//
//  MatchupViewController.m
//  Ultra meetup
//
//  Created by Vedran Burojevic on 6/25/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "MatchupViewController.h"
#import "Group.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

static const CGFloat ChoosePersonButtonHorizontalPadding = 80.f;
static const CGFloat ChoosePersonButtonVerticalPadding = 20.f;

@interface MatchupViewController ()
@property (nonatomic, strong) NSMutableArray *groups;
@end

@implementation MatchupViewController

#pragma mark - Object Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // This view controller maintains a list of ChoosePersonView
        // instances to display.
        _groups = [[self defaultGroups] mutableCopy];
    }
    return self;
}

#pragma mark - UIViewController Overrides

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Display the first ChoosePersonView in front. Users can swipe to indicate
    // whether they like or dislike the person displayed.
    self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
    [self.view addSubview:self.frontCardView];
    
    // Display the second ChoosePersonView in back. This view controller uses
    // the MDCSwipeToChooseDelegate protocol methods to update the front and
    // back views after each user swipe.
    self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view
{
    //    NSLog(@"You couldn't decide on %@.", self.currentPerson.name);
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction
{
    // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
    // and "LIKED" on swipes to the right.
    if (direction == MDCSwipeDirectionLeft) {
        //        NSLog(@"You noped %@.", self.currentPerson.name);
    } else {
        //        NSLog(@"You liked %@.", self.currentPerson.name);
    }
    
    // MDCSwipeToChooseView removes the view from the view hierarchy
    // after it is swiped (this behavior can be customized via the
    // MDCSwipeOptions class). Since the front card view is gone, we
    // move the back card to the front, and create a new back card.
    self.frontCardView = self.backCardView;
    if ((self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]])) {
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
    }
}

#pragma mark - Internal Methods

- (void)setFrontCardView:(ChooseGroupView *)frontCardView
{
    _frontCardView = frontCardView;
    self.currentPerson = frontCardView.group;
}

- (NSArray *)defaultGroups
{
    // It would be trivial to download these from a web service
    // as needed, but for the purposes of this sample app we'll
    // simply store them in memory.
    
    Group *group1 = [[Group alloc] initWithGroupID:@"1" country:@"Croatia" groupDescription:@"Ekipa" gender:1 members:@[@"Ivana", @"Matea", @"Vanja"] photos:@[[UIImage imageNamed:@"girls"]] likedGroups:@[@"afkj6VB8ddHGHswd54"] dislikedGroups:@[@"nBK66fghcHHG6FfseR"]];
    
    Group *group2 = [[Group alloc] initWithGroupID:@"1" country:@"Croatia" groupDescription:@"Ekipa" gender:1 members:@[@"Ana", @"Nikolina", @"Tanja", @"Dora"] photos:@[[UIImage imageNamed:@"girls"]] likedGroups:@[@"afkj6VB8ddHGHswd54"] dislikedGroups:@[@"nBK66fghcHHG6FfseR"]];
    
    Group *group3 = [[Group alloc] initWithGroupID:@"1" country:@"Croatia" groupDescription:@"Ekipa" gender:1 members:@[@"Katarina", @"Maja", @"Anja"] photos:@[[UIImage imageNamed:@"girls"]] likedGroups:@[@"afkj6VB8ddHGHswd54"] dislikedGroups:@[@"nBK66fghcHHG6FfseR"]];
    
    Group *group4 = [[Group alloc] initWithGroupID:@"1" country:@"Croatia" groupDescription:@"Ekipa" gender:1 members:@[@"Sara", @"Ida", @"Dorotea"] photos:@[[UIImage imageNamed:@"girls"]] likedGroups:@[@"afkj6VB8ddHGHswd54"] dislikedGroups:@[@"nBK66fghcHHG6FfseR"]];
    
    Group *group5 = [[Group alloc] initWithGroupID:@"1" country:@"Croatia" groupDescription:@"Ekipa" gender:1 members:@[@"Lana", @"Andrea", @"Valentina"] photos:@[[UIImage imageNamed:@"girls"]] likedGroups:@[@"afkj6VB8ddHGHswd54"] dislikedGroups:@[@"nBK66fghcHHG6FfseR"]];
    
    return @[group1, group2, group3, group4, group5];
}

- (ChooseGroupView *)popPersonViewWithFrame:(CGRect)frame
{
    if ([self.groups count] == 0) {
        return nil;
    }
    
    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };
    
    // Create a groupView with the top group in the group array, then pop
    // that group off the stack.
    ChooseGroupView *personView = [[ChooseGroupView alloc] initWithFrame:frame
                                                                    group:self.groups[0]
                                                                   options:options];
    [self.groups removeObjectAtIndex:0];
    return personView;
}

#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 100.f;
    CGFloat bottomPadding = 200.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 10.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}

// Create and add the "nope" button.
- (void)constructNopeButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"nope"];
    button.frame = CGRectMake(ChoosePersonButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:247.f/255.f
                                         green:91.f/255.f
                                          blue:37.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(nopeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

// Create and add the "like" button.
- (void)constructLikedButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"liked"];
    button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width - ChoosePersonButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:29.f/255.f
                                         green:245.f/255.f
                                          blue:106.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(likeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark Control Events

// Programmatically "nopes" the front card view.
- (void)nopeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}

// Programmatically "likes" the front card view.
- (void)likeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}

@end
