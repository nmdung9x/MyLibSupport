//
//  LocationUtils.m
//  Sapo 360
//
//  Created by DungNM-PC on 11/06/2021.
//

#import "LocationUtils.h"
#import "LogUtils.h"

@interface LocationUtils () <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLLocation *myLocation, *lastLocation;
    BOOL requestLocation, ignoreLocationError;
}

@end

@implementation LocationUtils

- (id) init;
{
    self = [super init];
    if (self) {
        if (locationManager == nil) {
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
            
        }
        [self requestCheckLocation];
    }
    return self;
}

- (BOOL) checkLocationEnabled;
{
    return [CLLocationManager locationServicesEnabled];
}

- (int) checkAuthorization;
{
    if (@available(iOS 14.0, *)) {
        if (locationManager.authorizationStatus == kCLAuthorizationStatusDenied ||
            locationManager.authorizationStatus == kCLAuthorizationStatusRestricted) {
            return -1;
        }
        if (locationManager.authorizationStatus == kCLAuthorizationStatusNotDetermined) {
            [locationManager requestWhenInUseAuthorization];
            return 0;
        }
    } else {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
            [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
            return -1;
        }
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            [locationManager requestWhenInUseAuthorization];
            return 0;
        }
    }
    return 1;
}

- (void) requestCheckLocation;
{
    if ([self checkLocationEnabled]) {
        DLog(@"auth status: %d", [self checkAuthorization]);
        if ([self checkAuthorization] == 1) {
            requestLocation = YES;
            ignoreLocationError = NO;
            [locationManager startUpdatingLocation];
        } else if ([self checkAuthorization] == -1) {
            if ([self.delegate respondsToSelector:@selector(requestAuthorizationDenied)]) {
                [self.delegate requestAuthorizationDenied];
            }
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(locationServicesDisabled)]) {
            [self.delegate locationServicesDisabled];
        }
    }
}

- (void) stopCheckLocation;
{
    if (locationManager) {
        [locationManager stopUpdatingLocation];
        locationManager = nil;
        requestLocation = NO;
    }
}

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager;
{
    DLog(@"");
    locationManager = manager;
    [self requestCheckLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    DLog(@"");
    lastLocation = [locations lastObject];
    
    if (requestLocation) {
        myLocation = lastLocation;
        requestLocation = NO;
        ignoreLocationError = NO;
        [locationManager stopUpdatingLocation];
        
        if ([self.delegate respondsToSelector:@selector(locationUpdate:)]) {
            [self.delegate locationUpdate:myLocation];
        }
    }
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;
{
    DLog(@"%@", [error description]);
    if (ignoreLocationError) return;
    ignoreLocationError = YES;
    if (requestLocation) {
        requestLocation = NO;
        
        if ([self checkAuthorization] == -1) {
            if ([self.delegate respondsToSelector:@selector(requestAuthorizationDenied)]) {
                [self.delegate requestAuthorizationDenied];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(locationFailWithError:)]) {
                [self.delegate locationFailWithError:error];
            }
        }
    }
}

@end
