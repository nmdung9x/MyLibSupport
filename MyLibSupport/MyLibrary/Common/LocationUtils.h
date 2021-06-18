//
//  LocationUtils.h
//  Sapo 360
//
//  Created by DungNM-PC on 11/06/2021.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LocationUtilsDelegate;

@interface LocationUtils : NSObject

@property (nonatomic, weak) id<LocationUtilsDelegate> delegate;

- (BOOL) checkLocationEnabled;
- (void) requestCheckLocation;
- (void) stopCheckLocation;

@end

@protocol LocationUtilsDelegate <NSObject>

@optional

- (void) locationServicesDisabled;
- (void) requestAuthorizationDenied;
- (void) locationUpdate:(CLLocation *)location;
- (void) locationFailWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
