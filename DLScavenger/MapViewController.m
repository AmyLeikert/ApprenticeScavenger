//
//  MapViewController.m
//  DLScavenger
//
//  Created by Detroit Labs User on 3/24/14.
//  Copyright (c) 2014 DetroitLabsUser. All rights reserved.
//

#import "MapViewController.h"
#import "Reachability.h"


@interface MapViewController ()

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@end

Reachability    *internetReach;
BOOL             internetAvailable;

@implementation MapViewController

- (void)updateReachabilityStatus:(Reachability *)curReach {
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus != NotReachable) {
        NSLog(@"I:Y");
        internetAvailable = YES;
    } else {
        NSLog(@"I:N");
        internetAvailable = NO;
    }
}

#pragma mark - Map View Methods

- (void) startLocationMonitoring {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startMonitoringSignificantLocationChanges];
}

- (void) stopLocationMonitoring {
    [locationManager stopMonitoringSignificantLocationChanges];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *lastLocation = locations.lastObject;
    NSLog(@"Location: %f,%f", lastLocation.coordinate.latitude, lastLocation.coordinate.longitude);
    //[_mapView showAnnotations:[_mapView annotations] animated:YES];
    [self zoomToLocationWithLat:lastLocation.coordinate.latitude andLon:lastLocation.coordinate.longitude];
}

- (void)zoomToLocationWithLat:(float)latitude andLon:(float)longitude{
    if (latitude == 0 || longitude == 0) {
        NSLog(@"No Coordinates");
    } else {
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = latitude;
        zoomLocation.longitude = longitude;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1000, 1000);
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion animated:YES];
    }
}


#pragma mark - Interactivity Methods

- (void) reachabilityChanged:(NSNotification *)note {
    Reachability *reach = (Reachability *)[note object];
    [self updateReachabilityStatus:reach];
}


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
    internetReach = [Reachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [internetReach startNotifier];
    [self updateReachabilityStatus:internetReach];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLocationMonitoring) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopLocationMonitoring) name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
