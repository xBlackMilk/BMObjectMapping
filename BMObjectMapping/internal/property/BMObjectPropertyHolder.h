//
// Created by blackmilk on 13-7-20.
//
// 
//


#import <Foundation/Foundation.h>

@class BMObjectProperty;
@class BMObjectProperties;


@interface BMObjectPropertyHolder : NSObject

+ (BMObjectPropertyHolder *)instance;

- (BMObjectProperty *)propertyOfClass:(Class)cls propertyName:(NSString *)name;

- (BMObjectProperties *)propertiesOfClass:(Class)cls;

@end