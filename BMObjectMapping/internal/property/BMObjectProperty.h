//
// Created by blackmilk on 13-7-20.
//
// 
//


#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@interface BMObjectProperty : NSObject

/**
* 属性名
*/
@property(readonly) NSString *propertyName;

/**
* 类型名
*/
@property(readonly) NSString *typeName;

/**
* 是否为NSString类型属性
*/
@property(readonly) BOOL isString;

/**
* 是否为数字类型属性,对于以下类型的都归位数字类型
* int,unsigned int,
* long,unsigned long,
* long long, unsigned long long,
* short,unsigned short,
* bool,
* double,float
* chat,unsigned char
* NSNumber
*/
@property(readonly) BOOL isNumber;

/**
* 是否为NSDate类型属性
*/
@property(readonly) BOOL isDate;

/**
* 是否为NSArray类型属性
*/
@property(readonly) BOOL isArray;

/**
* 是否为NSSet类型属性
*/
@property(readonly) BOOL isSet;

/**
* 是否为NSDictionary类型属性
*/
@property(readonly) BOOL isDictionary;

/**
* 是否为NSURL类型属性
*/
@property(readonly) BOOL isUrl;

/**
* 是否为非上面的类型
*/
@property(readonly) BOOL isOtherType;

/**
* 是否为只读属性
*/
@property(readonly) BOOL isReadonly;

- (id)initWithProp:(objc_property_t)prop;

@end