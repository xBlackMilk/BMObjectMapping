//
// Created by blackmilk on 13-7-20.
//
// 
//


#import <Foundation/Foundation.h>


@interface BMMappingConfig : NSObject

/**
* 配置文件中,JSON属性的Key集合
*/
@property(readonly) NSSet *keySet;

/**
* 每个属性的转换器集合
*/
@property(readonly) NSArray *converters;

- (BOOL)loadFromFile:(NSString *)path;

@end