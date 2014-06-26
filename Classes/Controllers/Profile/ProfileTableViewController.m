//
//  ProfileTableViewController.m
//  Ultra meetup
//
//  Created by Filip Beć on 21/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "SimpleInputTableViewCell.h"
#import "PhotosTableViewCell.h"
#import "CountryList.h"
#import <SVProgressHUD.h>

typedef NS_ENUM(NSInteger, Gender) {
    GenderNone = -1,
    GenderMale = 0,
    GenderFemale = 1,
    GenderMixed = 2
};

@interface ProfileTableViewController ()

@property (nonatomic, retain) NSMutableOrderedSet *friends;
@property (nonatomic, retain) CountryList *countryList;
@property (nonatomic, retain) NSArray *genderList;

@property (nonatomic, retain) UIPickerView *countryPicker;
@property (nonatomic, retain) UIPickerView *genderPicker;

@property (nonatomic, assign) Gender selectedGender;
@property (nonatomic, retain) NSString *selectedCountry;

@property (nonatomic, assign) NSInteger selectedPhotoButtonTag;

@property (nonatomic, retain) NSMutableArray *photos;

- (IBAction)doneBarButtonItemTapped:(UIBarButtonItem *)sender;
@end

@implementation ProfileTableViewController

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
    
    self.tableView.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    self.friends = [[NSMutableOrderedSet alloc] init];
    self.photos = [[NSMutableArray alloc] init];
    
    self.countryList = [[CountryList alloc] init];
    self.genderList = [[NSArray alloc] initWithObjects:@"Male", @"Female", @"Mixed", nil];
    
    self.selectedCountry = nil;
    self.selectedGender = GenderNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.friends.count + 1;
            
        case 1:
            return 2;
            
        case 2:
            return 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 320;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return [self tableView:tableView cellForFirstSectionWithIndexPath:indexPath];
            
        case 1:
            return [self tableView:tableView cellForSecondSectionWithIndexPath:indexPath];
            
        case 2:
            return [self tableView:tableView cellForThirdSectionWithIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForFirstSectionWithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.friends.count) {
        PFUser *friend = [self.friends objectAtIndex:indexPath.row];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
        cell.textLabel.text = [friend objectForKey:@"name"];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddMemberCell" forIndexPath:indexPath];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSecondSectionWithIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            SimpleInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddMemberCell" forIndexPath:indexPath];
            
            cell.textField.placeholder = @"Country";
            cell.textField.userInteractionEnabled = YES;
            cell.textField.enabled = YES;
            
            cell.textField.inputView = self.countryPicker;
            cell.textField.text = self.selectedCountry;
            
            return cell;
        }
            
        case 1: {
            SimpleInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddMemberCell" forIndexPath:indexPath];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textField.placeholder = @"Gender";
            cell.textField.userInteractionEnabled = YES;
            cell.textField.enabled = YES;
            
            cell.textField.inputView = self.genderPicker;
            if (self.selectedGender != GenderNone) {
                cell.textField.text = [self.genderList objectAtIndex:self.selectedGender];
            }
            
            return cell;
        }
            
        case 2:
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForThirdSectionWithIndexPath:(NSIndexPath *)indexPath
{
    PhotosTableViewCell *cell = (PhotosTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhotosCell" forIndexPath:indexPath];
    
    [cell.photo1 addTarget:self action:@selector(photoButtonActionHandler:) forControlEvents:UIControlEventTouchUpInside];
    [cell.photo2 addTarget:self action:@selector(photoButtonActionHandler:) forControlEvents:UIControlEventTouchUpInside];
    [cell.photo3 addTarget:self action:@selector(photoButtonActionHandler:) forControlEvents:UIControlEventTouchUpInside];
    [cell.photo4 addTarget:self action:@selector(photoButtonActionHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger i = 0;
    NSArray *photoButtons = @[cell.photo1, cell.photo2, cell.photo3, cell.photo4];
    
    while (i < self.photos.count) {
        UIButton *b = [photoButtons objectAtIndex:i];
        [b setImage:[self.photos objectAtIndex:i] forState:UIControlStateNormal];
        ++i;
    }
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row < self.friends.count) {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.friends removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[[segue destinationViewController] topViewController] isKindOfClass:[PeopleLookupTableViewController class]]) {
        PeopleLookupTableViewController *vc = (PeopleLookupTableViewController *)[[segue destinationViewController] topViewController];
        vc.delegate = self;
    }
}

#pragma mark - People lookup delegate

- (void)peopleLookupController:(PeopleLookupTableViewController *)controller didSelectFriend:(PFUser *)user
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.friends.count inSection:0];
    [self.friends addObject:user];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (UIPickerView *)countryPicker
{
    if (!_countryPicker) {
        _countryPicker = [[UIPickerView alloc] init];
        _countryPicker.delegate = self;
        _countryPicker.delegate = self;
    }
    
    return _countryPicker;
}

- (UIPickerView *)genderPicker
{
    if (!_genderPicker) {
        _genderPicker = [[UIPickerView alloc] init];
        _genderPicker.delegate = self;
        _genderPicker.dataSource = self;
    }
    return _genderPicker;
}

#pragma mark -  Picker view data source
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == self.countryPicker) {
        return 1;
        
    } else if (pickerView == self.genderPicker) {
        return 1;
    }
    
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.countryPicker) {
        return [self.countryList.objects count];
        
    } else if (pickerView == self.genderPicker) {
        return 3;
    }
    
    return 0;
}

#pragma mark - Picker view delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.countryPicker) {
        return [self.countryList.objects objectAtIndex:row];
        
    } else if (pickerView == self.genderPicker) {
        return [self.genderList objectAtIndex:row];
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.countryPicker) {
        self.selectedCountry = [self.countryList.objects objectAtIndex:row];
        
        SimpleInputTableViewCell *cell = (SimpleInputTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        cell.textField.text = self.selectedCountry;
        
    } else if (pickerView == self.genderPicker) {
        self.selectedGender = row;
        
        SimpleInputTableViewCell *cell = (SimpleInputTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        cell.textField.text = [self.genderList objectAtIndex:self.selectedGender];
    }
}

#pragma mark -
#pragma mark - Photos
#pragma mark -

- (void)photoButtonActionHandler:(id)sender
{
    UIButton *button = sender;
    self.selectedPhotoButtonTag = button.tag;
    
    [self showActionSheet];
}

- (void)showActionSheet
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Select from camera roll", @"Take a photo", nil];
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
        
    } else {
        [self createAndShowImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

- (void)createAndShowImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = sourceType;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - ActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self createAndShowImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    } else if (buttonIndex == 1) {
        [self createAndShowImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }
}

#pragma mark - Image picker controller delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage *editedImage = (UIImage*)[info objectForKey:UIImagePickerControllerEditedImage];
        
        if (self.photos.count < 4 && self.photos.count < self.selectedPhotoButtonTag) {
            [self.photos addObject:editedImage];
        } else {
            [self.photos replaceObjectAtIndex:self.selectedPhotoButtonTag-1 withObject:editedImage];
        }

        [self.tableView reloadData];
    }];
    
}

- (IBAction)doneBarButtonItemTapped:(UIBarButtonItem *)sender
{
    [SVProgressHUD show];
    
    PFObject *group = [PFObject objectWithClassName:@"Group"];
    
    group[@"users"] = self.friends.array;
    
    group[@"country"] = self.selectedCountry;
    group[@"gender"] = [NSNumber numberWithInt:self.selectedGender];

    NSMutableArray *imageFiles = [NSMutableArray array];
    
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t dispatchGroup = dispatch_group_create();
    
    for (UIImage *image in self.photos) {
        dispatch_group_enter(dispatchGroup);
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        PFFile *imageFile = [PFFile fileWithName:@"groupImage.png" data:imageData];
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [imageFiles addObject:imageFile];
            } else {
                NSLog(@"[ERROR] Failed to save image with error: %@", error.localizedDescription);
            }
            dispatch_group_leave(dispatchGroup);
        }];
    }
    
    dispatch_group_notify(dispatchGroup, dispatchQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            group[@"images"] = imageFiles;
            
            [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [SVProgressHUD showSuccessWithStatus:@"Group created successfully!"];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"Failed to create group!"];
                    NSLog(@"[ERROR] Failed to create group with error: %@", error.localizedDescription);
                }
            }];
        });
    });
}

@end
