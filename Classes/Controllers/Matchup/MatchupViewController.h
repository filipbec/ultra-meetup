//
//  MatchupViewController.h
//  Ultra meetup
//
//  Created by Vedran Burojevic on 6/25/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseGroupView.h"

@interface MatchupViewController : UIViewController <MDCSwipeToChooseDelegate>

@property (nonatomic, strong) Group *currentPerson;
@property (nonatomic, strong) ChooseGroupView *frontCardView;
@property (nonatomic, strong) ChooseGroupView *backCardView;

@end
