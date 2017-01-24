//
//  GetLocationFromMapViewController.h
//  SampleForKaaylabs
//
//  Created by admin on 1/20/17.
//  Copyright © 2017 Venugopal Devarala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@import GoogleMaps;

@interface GetLocationFromMapViewController : UIViewController<CLLocationManagerDelegate,GMSMapViewDelegate>
{
    CLLocationManager *locationManager;
    CLLocation * currentLocationCoordinates;
    NSManagedObjectContext * managedObjectContext;
}
@property (nonatomic) CLLocationCoordinate2D currentCoordinates;
@property (strong, nonatomic) IBOutlet UIImageView *markerIcon;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIButton *currentLocationButton;



- (IBAction)closeButtonClicked:(id)sender;
- (IBAction)currentLocationButtonClicked:(id)sender;

@end
