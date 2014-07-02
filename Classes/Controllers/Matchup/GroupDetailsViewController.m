//
//  GroupDetailsViewController.m
//  Ultra meetup
//
//  Created by Vedran Burojevic on 7/1/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "GroupDetailsViewController.h"
#import "Group.h"

#import <UIImageView+AFNetworking.h>

@interface GroupDetailsViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *headerScrollView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupDescriptionLabel;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) float descriptionCellHeight;

@end

@implementation GroupDetailsViewController

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureTableView];
    
    [SVProgressHUD show];
    [self.group refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.group = (Group *)object;
        [self configureAppearance];
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Appearance

- (void)configureAppearance
{
//    [self configureNavigationBarButtonItems];
    [self configureScrollViewAndPageControl];
    [self configureTableViewInformation];
}

- (void)configureScrollViewAndPageControl
{
    for (int i = 0; i < self.group.images.count; i++) {
        CGRect frame;
        frame.origin.x = self.headerScrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.headerScrollView.frame.size;
        
        PFFile *imageFile = self.group.images[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [imageView setImageWithURL:[NSURL URLWithString:imageFile.url]];
        [self.headerScrollView addSubview:imageView];
    }
    
    self.headerScrollView.contentSize = CGSizeMake(self.headerScrollView.frame.size.width * self.group.images.count, self.headerScrollView.frame.size.height);
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.numberOfPages = self.group.images.count;
    self.pageControl.currentPage = 0;
    
    UIView *pageControlView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.pageControl.frame.size.width, self.pageControl.frame.size.height)];
    pageControlView.frame = CGRectMake(100.0, 0.0, self.pageControl.frame.size.width, self.pageControl.frame.size.height);
    [pageControlView addSubview:self.pageControl];
    self.navigationItem.titleView = pageControlView;
}

- (void)configureNavigationBarButtonItems
{
    UIButton *likeButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [likeButton setImage:[UIImage imageNamed:@"likeButtonWhite"] forState:UIControlStateNormal];
    [likeButton addTarget:self action:@selector(likeBarButtonItemTapped:)forControlEvents:UIControlEventTouchUpInside];
    [likeButton setFrame:CGRectMake(0.0, 0.0, 29, 29)];
    UIBarButtonItem *likeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:likeButton];
    
    UIButton *dislikeButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [dislikeButton setImage:[UIImage imageNamed:@"dislikeButtonWhite"] forState:UIControlStateNormal];
    [dislikeButton addTarget:self action:@selector(dislikeBarButtonItemTapped:)forControlEvents:UIControlEventTouchUpInside];
    [dislikeButton setFrame:CGRectMake(0.0, 0.0, 29, 29)];
    UIBarButtonItem *dislikeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:dislikeButton];
    
    self.navigationItem.rightBarButtonItems = @[likeBarButtonItem, dislikeBarButtonItem];
}

- (void)configureTableView
{
    self.tableView.tableFooterView = [UIView new];
}

- (void)configureTableViewInformation
{
    self.groupNameLabel.text = self.group.fullName;
    self.groupNameLabel.textColor = PURPLE_COLOR;
    
    self.groupDescriptionLabel.text = self.group.groupDescription;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        [self.groupDescriptionLabel sizeToFit];
        return self.groupDescriptionLabel.bounds.size.height + 50;
    }
    else
    {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

#pragma mark - Like/Dislike

- (void)likeBarButtonItemTapped:(UIBarButtonItem *)barButtonItem
{
    if ([self.delegate respondsToSelector:@selector(groupDetailsViewControllerDidLikeGroup)]) {
        [self.delegate groupDetailsViewControllerDidLikeGroup];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dislikeBarButtonItemTapped:(UIBarButtonItem *)barButtonItem
{
    if ([self.delegate respondsToSelector:@selector(groupDetailsViewControllerDidDislikeGroup)]) {
        [self.delegate groupDetailsViewControllerDidDislikeGroup];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = self.headerScrollView.frame.size.width;
    int page = floor((self.headerScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

@end
