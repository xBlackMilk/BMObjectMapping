//
// Created by blackmilk on 13-7-20.
//
// 
//


#import "MyMapper.h"


@implementation MyMapper {

}

+ (CLLocationCoordinate2D)mapLocation:(NSArray *)array {
    return CLLocationCoordinate2DMake(100, 100);
}

+ (NSString *)map1:(NSArray *)array {
    return @"呵呵";
}

+ (unsigned int)map2:(NSArray *)array {
    return 100;
}


@end