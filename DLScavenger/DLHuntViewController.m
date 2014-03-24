//
//  DLHuntViewController.m
//  DLScavenger
//
//  Created by DetroitLabsUser on 3/24/14.
//  Copyright (c) 2014 DetroitLabsUser. All rights reserved.
//

#import "DLHuntViewController.h"
#import "Reachability.h"

@interface DLHuntViewController ()

@property (nonatomic,strong) IBOutlet UILabel *scoreLabel;
@property (nonatomic,strong) IBOutlet UILabel *foundCluesLabel;
@property (nonatomic,strong) IBOutlet UILabel *totalCluesLabel;
@property (nonatomic,strong) IBOutlet UITableView *cluesTableView;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;


@end

// Reachability setup
Reachability    *internetReach;
BOOL             internetAvailable;

@implementation DLHuntViewController

#pragma mark - Core Methods
//  This is used for reachability
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

//This is all the locaitons view work
- (void)startLocationMonitoring {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [locationManager startMonitoringSignificantLocationChanges];
}

- (void)stopLocationMonitoring {
    [locationManager stopMonitoringSignificantLocationChanges];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Location Updated");
    CLLocation *lastLocation = locations.lastObject;
    NSLog(@"%f,%f",lastLocation.coordinate.latitude, lastLocation.coordinate.longitude);
    //    [_mapView showAnnotations:[_mapView annotations] animated:YES];
    [self zoomToLocationWithLat:lastLocation.coordinate.latitude andLon:lastLocation.coordinate.longitude];
}

- (void)zoomToLocationWithLat:(float)latitude andLon:(float)longitude {
    if (latitude == 0 || longitude == 0) {
        NSLog(@"No Coordinates");
    } else {
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = latitude;
        zoomLocation.longitude = longitude;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 3000, 3000);
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion animated:YES];
    }
}


// Map pins
- (void)annotateMapLocations
{
    NSMutableArray *locs = [[NSMutableArray alloc]init];
    for (id <MKAnnotation> annot in [_mapView annotations]) {
        if ([annot isKindOfClass:[MKPointAnnotation class]]) {
            [locs addObject:annot];
        }
    }
    [_mapView removeAnnotations:locs];
    
    NSMutableArray *annotationArray = [[NSMutableArray alloc] init];
    
//    for (NSDictionary *location in /* This is where the array goes */) {
//        MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
//        pa.coordinate = CLLocationCoordinate2DMake([[location objectForKey:@"lat"] floatValue], [[location objectForKey:@"lon"] floatValue]);
//        pa.title = [location objectForKey:@"name"];
//        pa.subtitle = [location objectForKey:@"address"];
//        [annotationArray addObject:pa];
//    }
//    [_mapView addAnnotations:annotationArray];
//    [_mapView showAnnotations:[_mapView annotations] animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // This is used for resusing pins in the view
    if (annotation != mapView.userLocation) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
            annotationView.canShowCallout = YES;
            annotationView.animatesDrop = YES;
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}

#pragma mark - Interactivity Methods

- (void) reachabilityChanged:(NSNotification *)note {
    Reachability *reach = (Reachability *)[note object];
    [self updateReachabilityStatus:reach];
}





#pragma mark - System Methods

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
//    This is for reachability
	internetReach = [Reachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [internetReach startNotifier];
    [self updateReachabilityStatus:internetReach];
    
    
    //    this is for the map
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLocationMonitoring) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopLocationMonitoring) name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //   insert self annotate with map locations here
//    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"ATMs" ofType:@"plist"];
//    _atmDictionaryArray = [[NSMutableArray alloc] initWithContentsOfFile:bundlePath];
//    NSLog(@"Count: %i",[_atmDictionaryArray count]);
    
    [self annotateMapLocations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
