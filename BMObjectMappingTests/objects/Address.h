//
// Created by blackmilk on 13-7-20.
//
// 
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Address : NSObject

@property(nonatomic, assign) NSInteger cityId;
@property(nonatomic, strong) NSString *cityName;
@property(nonatomic, assign) int testSel;
@property(nonatomic, assign) CLLocationCoordinate2D location;

@end