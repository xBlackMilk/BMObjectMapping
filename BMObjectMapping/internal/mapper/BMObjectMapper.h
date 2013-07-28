//
// Created by blackmilk on 13-7-16.
//
// 
//


#import <Foundation/Foundation.h>
#import "BMMapper.h"


@interface BMObjectMapper : BMMapper

@property(nonatomic, strong) Class targetClass;

- (id)initWithKey:(NSString *)key propertyName:(NSString *)name targetClass:(Class)cls;

@end