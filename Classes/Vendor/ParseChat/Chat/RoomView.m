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
#import "SVProgressHUD.h"

#import "AppDefines.h"

#import "RoomView.h"
#import "ChatView.h"

#import "App.h"
#import "ChatRoom.h"

#import "ChatRoomTableViewCell.h"

@interface RoomView()

@property (nonatomic, strong) NSArray *rooms;

@end


@implementation RoomView

- (void)viewDidLoad
{
	[super viewDidLoad];
    
	self.title = @"Matches";
	self.tableView.separatorInset = UIEdgeInsetsZero;
    
	[self refreshTable];
}

- (void)refreshTable
{
    Group *group = [App instance].myGroup;
    
    if (group) {
        [SVProgressHUD show];
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group1 == %@ OR group2 == %@", group, group];
        PFQuery *query = [PFQuery queryWithClassName:[ChatRoom parseClassName] predicate:predicate];
        
        [query includeKey:@"group1"];
        [query includeKey:@"group2"];
        [query includeKey:@"group1.users"];
        [query includeKey:@"group2.users"];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error == nil) {
                self.rooms = objects;
                
                [SVProgressHUD dismiss];
                [self.tableView reloadData];
                
            } else {
                [SVProgressHUD showErrorWithStatus:@"Network error."];
            }
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.rooms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ChatRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatRoomTableViewCell"];
    
    ChatRoom *room = [self.rooms objectAtIndex:indexPath.row];
    Group *group = nil;
    
    if ([room.group1 isEqual:[App instance].myGroup]) {
        group = room.group2;
    } else {
        group = room.group1;
    }

    PFFile *image = [group.images firstObject];
    [cell.roomImageView setImageWithURL:[NSURL URLWithString:image.url]];
    cell.roomTitleLabel.text = group.fullName;

	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	ChatRoom *chatroom = [self.rooms objectAtIndex:indexPath.row];
	ChatView *chatView = [[ChatView alloc] initWith:chatroom];
    
	[self.navigationController pushViewController:chatView animated:YES];
}

@end
