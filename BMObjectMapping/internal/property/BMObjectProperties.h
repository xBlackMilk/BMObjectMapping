//
// Created by blackmilk on 13-7-20.
//
// 
//


#import <Foundation/Foundation.h>

@class BMObjectProperty;


@interface BMObjectProperties : NSObject

@property(readonly) NSArray *properties;
@property(readonly) Class targetClass;

- (id)initWithClass:(Class)cls;

- (BMObjectProperty *)propertyOfName:(NSString *)name;

@end