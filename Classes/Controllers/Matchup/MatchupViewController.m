//
//  MatchupViewController.m
//  Ultra meetup
//
//  Created by Vedran Burojevic on 6/25/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "MatchupViewController.h"
#import "Group.h"
#import "ChatRoom.h"
#import "App.h"
#import "MatchViewController.h"
#import "GroupDetailsViewController.h"

#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import <SVProgressHUD.h>

static const CGFloat ChoosePersonButtonHorizontalPadding = 80.f;
static const CGFloat ChoosePersonButtonVerticalPadding = 20.f;

@interface MatchupViewController () <GroupDetailsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bacgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (nonatomic, strong) NSMutableArray *groups;

@property (nonatomic, strong) Group *matchGroup;
@property (nonatomic, strong) ChatRoom *matchRoom;

@end

@implementation MatchupViewController

#pragma mark - Object Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // This view controller maintains a list of ChoosePersonView
        // instances to display.
    }
    return self;
}

#pragma mark - UIViewController Overrides

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.bacgroundImageView.alpha = 1.0;
    
    if (![App instance].myGroup) {
        self.bacgroundImageView.alpha = 0.0;
        self.infoLabel.text = @"In order to browse other people create your own group.";
        
    } else {
        [SVProgressHUD show];
        
        if (self.frontCardView) {
            [self.frontCardView removeFromSuperview];
            self.frontCardView = nil;
        }
        
        if (self.backCardView) {
            [self.backCardView removeFromSuperview];
            self.backCardView = nil;
        }
        
        Group *g = [App instance].myGroup;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (%@ IN likedBy) AND NOT (%@ IN dislikedBy) AND (%@ != objectId)", g, g, g.objectId];
        PFQuery *query = [PFQuery queryWithClassName:@"Group" predicate:predicate];
        
        [query includeKey:@"users"];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [SVProgressHUD dismiss];
            self.groups = [objects mutableCopy];
            
            if (self.groups.count <= 0) {
                self.infoLabel.text = @"There are no new groups";
                self.bacgroundImageView.alpha = 0.0;
            }

            UITapGestureRecognizer *frontCardViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openGroupDetailsScreen)];
            self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
            [self.frontCardView addGestureRecognizer:frontCardViewTapGestureRecognizer];
            [self.view addSubview:self.frontCardView];
            
            UITapGestureRecognizer *backCardViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openGroupDetailsScreen)];
            self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
            [self.backCardView addGestureRecognizer:backCardViewTapGestureRecognizer];
            [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        }];
    }
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
        [self.currentGroup addObject:[App instance].myGroup forKey:@"dislikedBy"];
    } else {
        Group *otherGroup = self.currentGroup;
        [otherGroup addObject:[App instance].myGroup forKey:@"likedBy"];
        
        [[App instance].myGroup refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            [App instance].myGroup = (Group *)object;
            
            Group *myGroup = [App instance].myGroup;
            if ([myGroup.likedBy containsObject:otherGroup]) {
                [self createChatRoomWithGroup:otherGroup];
            }
        }];
    }
    [self.currentGroup saveEventually];
    
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
    
    if (!self.frontCardView.subviews && !self.backCardView.superview && self.groups.count <= 0) {
        self.infoLabel.text = @"There are no new groups";
        self.bacgroundImageView.alpha = 0.0;
    }
}

#pragma mark - Internal Methods

- (void)setFrontCardView:(ChooseGroupView *)frontCardView
{
    _frontCardView = frontCardView;
    self.currentGroup = frontCardView.group;
}

- (ChooseGroupView *)popPersonViewWithFrame:(CGRect)frame
{
    if ([self.groups count] <= 0) {
        return nil;
        
    } else {
        self.bacgroundImageView.alpha = 1.0;
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

#pragma mark View Construction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 90.f;
    CGFloat bottomPadding = 130.f;
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

#pragma mark - Match
- (void)createChatRoomWithGroup:(Group *)group
{
    ChatRoom *room = [ChatRoom object];
    room.group1 = [App instance].myGroup;
    room.group2 = group;
    
    self.matchGroup = group;
    [room saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            self.matchRoom = room;
            [self openMatchScreen];
            [self sendPushToGroup:self.matchGroup];
            
        } else {
            [room saveEventually];
        }
    }];
}

- (void)sendPushToGroup:(Group *)group
{
    NSMutableArray *objectIDs = [NSMutableArray array];
    for (PFUser *u in group.users) {
        if ([u.objectId isEqualToString:[PFUser currentUser].objectId]) {
            continue;
        }
        [objectIDs addObject:u];
    }
    
    for (PFUser *u in [App instance].myGroup.users) {
        if ([u.objectId isEqualToString:[PFUser currentUser].objectId]) {
            continue;
        }
        [objectIDs addObject:u];
    }
    
    PFQuery *innerQuery = [PFUser query];
    [innerQuery whereKey:@"objectId" containedIn:objectIDs];
    
    PFQuery *query = [PFInstallation query];
    [query whereKey:@"user" matchesQuery:innerQuery];
    
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:query];
    [push setMessage:@"You have new match! Check your matches."];
    [push sendPushInBackground];
}

- (void)openMatchScreen
{
    [self performSegueWithIdentifier:@"match" sender:self];
}

#pragma mark - Details

- (void)openGroupDetailsScreen
{
    [self performSegueWithIdentifier:@"GroupDetails" sender:self];
}

#pragma mark - Group Details View Controller Delegate

- (void)groupDetailsViewControllerDidLikeGroup
{
    [self likeFrontCardView];
}

- (void)groupDetailsViewControllerDidDislikeGroup
{
    [self nopeFrontCardView];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"match"]) {
        MatchViewController *vc = (MatchViewController *)[segue.destinationViewController topViewController];
        vc.group = self.matchGroup;
        vc.chatroom = self.matchRoom;
        
    } else if ([segue.identifier isEqualToString:@"GroupDetails"]) {
        GroupDetailsViewController *groupDetailsViewController = segue.destinationViewController;
        groupDetailsViewController.group = self.currentGroup;
    }
}

@end
