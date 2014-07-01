//
// Copyright (c) 2014 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Parse/Parse.h>
#import <SVProgressHUD.h>

#import "AppDefines.h"
#import "App.h"

#import "ChatView.h"

@interface ChatView()
{
	NSTimer *timer;
	BOOL isLoading;
	
	ChatRoom *chatroom;
	
	NSMutableArray *users;
	NSMutableArray *messages;
	NSMutableDictionary *avatars;
	
	UIImageView *outgoingBubbleImageView;
	UIImageView *incomingBubbleImageView;
}

@property (nonatomic, retain) Group *otherGroup;

@end


@implementation ChatView

- (id)initWith:(ChatRoom *)chatroom_
{
	self = [super init];
	chatroom = chatroom_;
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"Chat";
    
    if ([[App instance].myGroup.objectId isEqualToString:chatroom.group1.objectId]) {
        self.otherGroup = chatroom.group2;
    } else {
        self.otherGroup = chatroom.group1;
    }
	
	users = [[NSMutableArray alloc] init];
	messages = [[NSMutableArray alloc] init];
	avatars = [[NSMutableDictionary alloc] init];
	
	self.sender = [PFUser currentUser].objectId;

	outgoingBubbleImageView = [JSQMessagesBubbleImageFactory outgoingMessageBubbleImageViewWithColor:[UIColor whiteColor]];
	incomingBubbleImageView = [JSQMessagesBubbleImageFactory incomingMessageBubbleImageViewWithColor:[UIColor whiteColor]];

	isLoading = NO;
	[self loadMessages];
	timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(loadMessages) userInfo:nil repeats:YES];
    self.collectionView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	self.collectionView.collectionViewLayout.springinessEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[timer invalidate];
}

- (void)loadMessages
{
	if (isLoading == NO) {
		isLoading = YES;
		JSQMessage *message_last = [messages lastObject];
		
		PFQuery *query = [PFQuery queryWithClassName:PF_CHAT_CLASS_NAME];
		[query whereKey:PF_CHAT_ROOM equalTo:chatroom];
        
		if (message_last != nil) {
            [query whereKey:PF_CHAT_CREATEDAT greaterThan:message_last.date];
        }
		[query includeKey:PF_CHAT_USER];
		[query orderByAscending:PF_CHAT_CREATEDAT];
        
		[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
			if (error == nil) {
				for (PFObject *object in objects) {
					PFUser *user = object[PF_CHAT_USER];
					[users addObject:user];
					
					JSQMessage *message = [[JSQMessage alloc] initWithText:object[PF_CHAT_TEXT] sender:user.objectId date:object.createdAt];
					[messages addObject:message];
				}
                
				if ([objects count] != 0) {
                    [self finishReceivingMessage];
                }
			} else {
                [SVProgressHUD showErrorWithStatus:@"Network error."];
            }
			isLoading = NO;
		}];
	}
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text sender:(NSString *)sender date:(NSDate *)date
{
	PFObject *object = [PFObject objectWithClassName:PF_CHAT_CLASS_NAME];
	object[PF_CHAT_ROOM] = chatroom;
	object[PF_CHAT_USER] = [PFUser currentUser];
	object[PF_CHAT_TEXT] = text;
    
	[object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
		if (error == nil) {
			[JSQSystemSoundPlayer jsq_playMessageSentSound];
            
            NSMutableArray *objectIDs = [NSMutableArray array];
            for (PFUser *u in chatroom.group1.users) {
                if ([u.objectId isEqualToString:[PFUser currentUser].objectId]) {
                    continue;
                }
                [objectIDs addObject:u];
            }
            
            for (PFUser *u in chatroom.group2.users) {
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
            [push setMessage:[NSString stringWithFormat:@"New message from %@", [[PFUser currentUser] objectForKey:@"name"]]];
            [push sendPushInBackground];
            
			[self loadMessages];
		} else {
            [SVProgressHUD showErrorWithStatus:@"Network error"];
        }
	}];
	[self finishSendingMessage];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
	NSLog(@"didPressAccessoryButton");
}

#pragma mark - JSQMessages CollectionView DataSource


- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return [messages objectAtIndex:indexPath.item];
}


- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView bubbleImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
	JSQMessage *message = [messages objectAtIndex:indexPath.item];
	if ([[message sender] isEqualToString:self.sender]) {
		return [[UIImageView alloc] initWithImage:outgoingBubbleImageView.image highlightedImage:outgoingBubbleImageView.highlightedImage];
	}
    
    return [[UIImageView alloc] initWithImage:incomingBubbleImageView.image highlightedImage:incomingBubbleImageView.highlightedImage];
}


- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
	PFUser *user = [users objectAtIndex:indexPath.item];
    PFFile *file = nil;
    
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blank_avatar"]];
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.layer.masksToBounds = YES;
    
    if ([[App instance].myGroup.users containsObject:user]) {
        file = [[App instance].myGroup.images firstObject];
    } else {
        file = [self.otherGroup.images firstObject];
    }
    [imageView setImageWithURL:[NSURL URLWithString:file.url]];

	return imageView;
}


- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.item % 3 == 0) {
		JSQMessage *message = [messages objectAtIndex:indexPath.item];
		return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
	}
	return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
	JSQMessage *message = [messages objectAtIndex:indexPath.item];
	if ([message.sender isEqualToString:self.sender]) {
		return nil;
	}
	
	if (indexPath.item - 1 > 0) {
		JSQMessage *previousMessage = [messages objectAtIndex:indexPath.item - 1];
		if ([[previousMessage sender] isEqualToString:message.sender]) {
			return nil;
		}
	}

	PFUser *user = [users objectAtIndex:indexPath.item];
	return [[NSAttributedString alloc] initWithString:user[@"name"] attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}


#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [messages count];
}


- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
	
	JSQMessage *message = [messages objectAtIndex:indexPath.item];
	if ([message.sender isEqualToString:self.sender]) {
		cell.textView.textColor = [UIColor blackColor];
	} else {
		cell.textView.textColor = [UIColor blackColor];
	}
    cell.textView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
	
	cell.textView.linkTextAttributes = @{NSForegroundColorAttributeName:cell.textView.textColor,
										 NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid)};
	
	return cell;
}

#pragma mark - JSQMessages collection view flow layout delegate

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.item % 3 == 0) {
		return kJSQMessagesCollectionViewCellLabelHeightDefault;
	}
    
	return 0.0f;
}


- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
	JSQMessage *message = [messages objectAtIndex:indexPath.item];
	if ([[message sender] isEqualToString:self.sender]) {
		return 0.0f;
	}
	
	if (indexPath.item - 1 > 0) {
		JSQMessage *previousMessage = [messages objectAtIndex:indexPath.item - 1];
		if ([[previousMessage sender] isEqualToString:[message sender]]) {
			return 0.0f;
		}
	}
    
	return kJSQMessagesCollectionViewCellLabelHeightDefault;
}


- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
	return 0.0f;
}


- (void)collectionView:(JSQMessagesCollectionView *)collectionView
				header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
	NSLog(@"didTapLoadEarlierMessagesButton");
}

@end
