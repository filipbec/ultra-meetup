//
//  MapViewController.m
//  Ultra meetup
//
//  Created by Filip Beć on 20/06/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//


#import "MapViewController.h"
#import "MapLocation.h"

@interface MapViewController () <UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) MapLocation *mainStageLocation;
@property (nonatomic, strong) MapLocation *arenaStageLocation;
@property (nonatomic, strong) MapLocation *radioStageLocation;

@end

@implementation MapViewController

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
    
    self.mainStageLocation = [[MapLocation alloc] initWithTitle:@"Main Stage" andCoordinates:CLLocationCoordinate2DMake(43.5244169,16.4342308)];
    self.arenaStageLocation = [[MapLocation alloc] initWithTitle:@"Ultra Worldwide Arena" andCoordinates:CLLocationCoordinate2DMake(43.5254169,16.4342308)];
    self.radioStageLocation = [[MapLocation alloc] initWithTitle:@"Radio Stage" andCoordinates:CLLocationCoordinate2DMake(43.5248169,16.4349308)];
    
    [self.mapView showAnnotations:@[self.mainStageLocation, self.arenaStageLocation, self.radioStageLocation] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Map View delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *identifier = @"MapViewAnnotation";
    
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (nil == annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.image = [UIImage imageNamed:@"pin"];
        annotationView.centerOffset = CGPointMake(0, -24);
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.canShowCallout = YES;
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MapLocation *selectedLocation = view.annotation;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Directions" message:[NSString stringWithFormat:@"Would you like to navigate to %@ using Apple Maps?", selectedLocation.title] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.delegate = self;
    
    [alert show];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self openInAppleMaps];
    }
}

#pragma mark - Navigation

- (void)openInAppleMaps
{
    MapLocation *selectedLocation = self.mapView.selectedAnnotations[0];
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:selectedLocation.coordinate
                                                   addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:selectedLocation.title];
    
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
    [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                   launchOptions:launchOptions];
}

@end
