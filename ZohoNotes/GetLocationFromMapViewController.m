//
//  GetLocationFromMapViewController.m
//  SampleForKaaylabs
//
//  Created by admin on 1/20/17.
//  Copyright © 2017 Venugopal Devarala. All rights reserved.
//

#import "GetLocationFromMapViewController.h"
#import "NotesDescriptionViewController.h"

@interface GetLocationFromMapViewController ()
{
    GMSMapView * mapView;
}
@end

@implementation GetLocationFromMapViewController

#define UnwindsegueToNotesDescriptionViewController @"unwindToNotesDecription"


- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_currentCoordinates.latitude
                                                            longitude:_currentCoordinates.longitude
                                                                 zoom:6];
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) camera:camera];
    mapView.myLocationEnabled = YES;
    [self.view addSubview: mapView];
    mapView.delegate = self;

    [self.view bringSubviewToFront:_closeButton];
    [self.view bringSubviewToFront:_markerIcon];
    [self.view bringSubviewToFront:_currentLocationButton];
}

- (UIImage *) screenshot {
    
    CGSize size = CGSizeMake(200, 200);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGRect rec = CGRectMake(0, 0, 200, 200);
    [self.view drawViewHierarchyInRect:rec afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark - UIButton Actions

-(void)closeButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:UnwindsegueToNotesDescriptionViewController sender:nil];
}

- (IBAction)currentLocationButtonClicked:(id)sender {
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat: 0.2] forKey:kCATransactionAnimationDuration];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: currentLocationCoordinates.coordinate.latitude longitude: currentLocationCoordinates.coordinate.longitude zoom: 17];
    [mapView animateToCameraPosition: camera];
    [CATransaction commit];
    
    _currentCoordinates = currentLocationCoordinates.coordinate;
}



#pragma mark - GoogleMaps Delegates

-(void)mapView:(GMSMapView *)mapview didChangeCameraPosition:(GMSCameraPosition *)position
{
    _currentCoordinates = [mapview.projection coordinateForPoint:mapView.center];
    NSLog(@"_currentCoordinates %f,%f",_currentCoordinates.latitude,_currentCoordinates.longitude);
}

-(void)mapView:(GMSMapView *)mapview idleAtCameraPosition:(GMSCameraPosition *)position
{
    _currentCoordinates = [mapview.projection coordinateForPoint:mapView.center];
     NSLog(@"%f,%f",_currentCoordinates.latitude,_currentCoordinates.longitude);
}


#pragma mark - Location Manager delegates

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
     currentLocationCoordinates = [locations objectAtIndex:0];
     NSLog(@"my latitude :%f",currentLocationCoordinates.coordinate.latitude);
     NSLog(@"my longitude :%f",currentLocationCoordinates.coordinate.longitude);
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertController * alertControllerToErrorMessage = [UIAlertController alertControllerWithTitle: @"" message: error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    [alertControllerToErrorMessage addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alertControllerToErrorMessage animated:YES completion:nil];

}

#pragma mark - Perform Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:UnwindsegueToNotesDescriptionViewController]) {
    NotesDescriptionViewController * notesDescriptionViewController= segue.destinationViewController;
    notesDescriptionViewController.mapImage = [self screenshot];
    notesDescriptionViewController.locationCoordinate = _currentCoordinates;
    }
}


@end
