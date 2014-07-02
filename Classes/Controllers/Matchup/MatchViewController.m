//
//  MatchViewController.m
//  Ultra meetup
//
//  Created by Filip Beć on 01/07/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "MatchViewController.h"
#import "App.h"


@interface MatchViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@property (nonatomic, retain, readonly) Group *myGroup;

@end

@implementation MatchViewController

@dynamic myGroup;

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
    
    self.titleLabel.font = [UIFont fontWithName:@"DOCK11-Heavy" size:28.0];
    
    self.imageView1.layer.masksToBounds = YES;
    self.imageView2.layer.masksToBounds = YES;
    
    self.imageView1.layer.cornerRadius = self.imageView1.frame.size.width / 2.0;
    self.imageView2.layer.cornerRadius = self.imageView2.frame.size.width / 2.0;
    
    self.imageView1.layer.borderColor = self.imageView2.layer.borderColor = [UIColor colorWithRed:84./255 green:84./255 blue:171./255 alpha:1.0].CGColor;
    
    self.imageView1.layer.borderWidth = 3;
    self.imageView2.layer.borderWidth = 3;
    
    PFFile *myImage = [self.myGroup.images firstObject];
    PFFile *otherImage = [self.group.images firstObject];
    
    [self.imageView1 setImageWithURL:[NSURL URLWithString:myImage.url]];
    [self.imageView2 setImageWithURL:[NSURL URLWithString:otherImage.url]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (Group *)myGroup
{
    return [App instance].myGroup;
}

- (IBAction)sendMessageButtonActionHandler:(id)sender
{
	ChatView *chatView = [[ChatView alloc] initWith:self.chatroom];
    chatView.fromPopup = YES;
	[self.navigationController pushViewController:chatView animated:YES];
}

- (IBAction)keepPlayingButtonActionHandler:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
