//
// ChoosePersonView.m
//
// Copyright (c) 2014 to present, Brian Gesiak @modocache
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "ChooseGroupView.h"
#import "ImageLabelView.h"
#import "Group.h"

static const CGFloat ChoosePersonViewImageLabelWidth = 42.f;

@interface ChooseGroupView ()
@property (nonatomic, strong) UIView *informationView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *dislikeButton;
@end

@implementation ChooseGroupView

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
                       group:(Group *)group
                      options:(MDCSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame options:options];
    if (self) {
        _group = group;
        
        PFFile *file = [_group.images firstObject];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            self.imageView.image = [UIImage imageWithData:data];
        }];

        self.imageView.contentMode = UIViewContentModeScaleAspectFill;

        [self constructInformationView];
        [self constructDislikeButton];
        [self constructLikeButton];
    }
    return self;
}

#pragma mark - Internal Methods

- (void)constructInformationView {
    CGFloat bottomHeight = 60.f;
    CGRect bottomFrame = CGRectMake(0,
                                    CGRectGetHeight(self.bounds) - bottomHeight,
                                    CGRectGetWidth(self.bounds),
                                    bottomHeight);
    _informationView = [[UIView alloc] initWithFrame:bottomFrame];
    _informationView.backgroundColor = [UIColor whiteColor];
    _informationView.clipsToBounds = YES;
    _informationView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                        UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_informationView];

    [self constructNameLabel];
}

- (void)constructNameLabel {
    CGFloat leftPadding = 12.f;
    CGFloat topPadding = 17.f;
    CGRect frame = CGRectMake(leftPadding,
                              _informationView.frame.size.height/2 - (CGRectGetHeight(_informationView.frame) - topPadding)/2,
                              170.0,
                              CGRectGetHeight(_informationView.frame) - topPadding);
    _nameLabel = [[UILabel alloc] initWithFrame:frame];

    NSMutableArray *names = [NSMutableArray array];
    for (PFUser *user in _group.users) {
        NSString *name = [user objectForKey:@"name"];
        if (name) {
            [names addObject:name];
        }
    }
    
    NSString *groupname = [names componentsJoinedByString:@", "];
    _nameLabel.text = groupname;
    
    _nameLabel.textColor = [UIColor purpleColor];
    [_informationView addSubview:_nameLabel];
}

- (void)constructDislikeButton
{
    UIImage *dislikeButtonImage = [UIImage imageNamed:@"dislikeButton"];
    
    CGFloat leftPadding = _informationView.frame.size.width - dislikeButtonImage.size.width * 2 - 20.0;
    CGFloat topPadding = 17.f;
    CGRect frame = CGRectMake(leftPadding,
                              topPadding,
                              dislikeButtonImage.size.width,
                              dislikeButtonImage.size.height);
    _dislikeButton = [[UIButton alloc] initWithFrame:frame];
    [_dislikeButton setImage:dislikeButtonImage forState:UIControlStateNormal];
    [_dislikeButton addTarget:self action:@selector(dislikeGroup) forControlEvents:UIControlEventTouchDown];
    
    [_informationView addSubview:_dislikeButton];
}

- (void)constructLikeButton
{
    UIImage *likeButtonImage = [UIImage imageNamed:@"likeButton"];
    
    CGFloat leftPadding = _informationView.frame.size.width - likeButtonImage.size.width - 10.0;
    CGFloat topPadding = 17.f;
    CGRect frame = CGRectMake(leftPadding,
                              topPadding,
                              likeButtonImage.size.width,
                              likeButtonImage.size.height);
    _likeButton = [[UIButton alloc] initWithFrame:frame];
    [_likeButton setImage:likeButtonImage forState:UIControlStateNormal];
    [_likeButton addTarget:self action:@selector(likeGroup) forControlEvents:UIControlEventTouchDown];
    
    [_informationView addSubview:_likeButton];
}

- (ImageLabelView *)buildImageLabelViewLeftOf:(CGFloat)x image:(UIImage *)image text:(NSString *)text {
    CGRect frame = CGRectMake(x - ChoosePersonViewImageLabelWidth,
                              0,
                              ChoosePersonViewImageLabelWidth,
                              CGRectGetHeight(_informationView.bounds));
    ImageLabelView *view = [[ImageLabelView alloc] initWithFrame:frame
                                                           image:image
                                                            text:text];
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    return view;
}

#pragma mark - Like and Dislike

// Programmatically "nopes" the front card view.
- (void)dislikeGroup {
    [self mdc_swipe:MDCSwipeDirectionLeft];
}

// Programmatically "likes" the front card view.
- (void)likeGroup {
    [self mdc_swipe:MDCSwipeDirectionRight];
}

@end
