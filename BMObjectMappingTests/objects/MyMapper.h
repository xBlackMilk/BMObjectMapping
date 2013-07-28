//
// Created by blackmilk on 13-7-20.
//
// 
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MyMapper : NSObject

+ (CLLocationCoordinate2D)mapLocation:(NSArray *)array;

+ (NSString *)map1:(NSArray *)array;

+ (unsigned int)map2:(NSArray *)array;

@end