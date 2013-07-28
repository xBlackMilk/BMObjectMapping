//
// Created by blackmilk on 13-7-20.
//
// 
//


#import "BMObjectProperty.h"

typedef enum {
    BM_PROPERTY_TYPE_NUMBER,
    BM_PROPERTY_TYPE_STRING,
    BM_PROPERTY_TYPE_DATE,
    BM_PROPERTY_TYPE_URL,
    BM_PROPERTY_TYPE_ARRAY,
    BM_PROPERTY_TYPE_DICTIONARY,
    BM_PROPERTY_TYPE_SET,
    BM_PROPERTY_TYPE_OTHER,
} BMObjectPropertyType;


@implementation BMObjectProperty {
    BMObjectPropertyType _type;
    NSString *_propertyName;
    NSString *_typeName;
    BOOL _isReadonly;
}


- (id)initWithProp:(objc_property_t)prop {
    self = [super init];
    if (self) {
        [self parseProp:prop];
    }

    return self;
}


- (NSString *)propertyName {
    return _propertyName;
}

- (NSString *)typeName {
    return _typeName;
}

- (BOOL)isReadonly {
    return _isReadonly;
}

- (BOOL)isString {
    return _type == BM_PROPERTY_TYPE_STRING;
}

- (BOOL)isNumber {
    return _type == BM_PROPERTY_TYPE_NUMBER;
}

- (BOOL)isDate {
    return _type == BM_PROPERTY_TYPE_DATE;
}

- (BOOL)isArray {
    return _type == BM_PROPERTY_TYPE_ARRAY;
}

- (BOOL)isDictionary {
    return _type == BM_PROPERTY_TYPE_DICTIONARY;
}

- (BOOL)isSet {
    return _type == BM_PROPERTY_TYPE_SET;
}

- (BOOL)isUrl {
    return _type == BM_PROPERTY_TYPE_URL;
}

- (BOOL)isOtherType {
    return _type == BM_PROPERTY_TYPE_OTHER;
}

#pragma mark Private

- (void)parseProp:(objc_property_t)prop {
    _propertyName = [NSString stringWithUTF8String:property_getName(prop)];
    _type = BM_PROPERTY_TYPE_OTHER;
    _isReadonly = YES;


    NSString *propAttributes = [NSString stringWithUTF8String:property_getAttributes(prop)];
    NSArray *attributeParts = [propAttributes componentsSeparatedByString:@","];
    if (attributeParts == nil || attributeParts.count <= 0) {
        return;
    }

    // number类型属性格式:  Ti , Td ,等等
    // 类属性类型格式: T@"class name"
    NSString *propType = [attributeParts[0] substringFromIndex:1];
    if ([propType hasPrefix:@"@"] && propType.length > 3) {
        propType = [propType substringWithRange:NSMakeRange(2, propType.length - 3)];
    }

    _typeName = propType;
    _type = [self parsePropType:propType];
    _isReadonly = [propAttributes rangeOfString:@",R,"].location != NSNotFound;
}

- (BMObjectPropertyType)parsePropType:(NSString *)typeName {
    //数字
    if ([typeName isEqualToString:@"NSNumber"] || // NSNumber
            [typeName isEqualToString:@"i"] || // int
            [typeName isEqualToString:@"I"] || // unsigned int
            [typeName isEqualToString:@"l"] || // long
            [typeName isEqualToString:@"L"] || // unsigned long
            [typeName isEqualToString:@"q"] || // long long
            [typeName isEqualToString:@"Q"] || // unsigned long long
            [typeName isEqualToString:@"s"] || // short
            [typeName isEqualToString:@"S"] || // unsigned short
            [typeName isEqualToString:@"B"] || // bool or _Bool
            [typeName isEqualToString:@"d"] || // Double
            [typeName isEqualToString:@"f"] || // float
            [typeName isEqualToString:@"c"] || // char
            [typeName isEqualToString:@"C"]) { // unsigned char
        return BM_PROPERTY_TYPE_NUMBER;
    } else if ([typeName isEqualToString:@"NSString"]) {
        return BM_PROPERTY_TYPE_STRING;
    } else if ([typeName isEqualToString:@"NSArray"]) {
        return BM_PROPERTY_TYPE_ARRAY;
    } else if ([typeName isEqualToString:@"NSDate"]) {
        return BM_PROPERTY_TYPE_DATE;
    } else if ([typeName isEqualToString:@"NSURL"]) {
        return BM_PROPERTY_TYPE_URL;
    } else if ([typeName isEqualToString:@"NSSet"]) {
        return BM_PROPERTY_TYPE_SET;
    } else if ([typeName isEqualToString:@"NSDictionary"]) {
        return BM_PROPERTY_TYPE_DICTIONARY;
    }
    return BM_PROPERTY_TYPE_OTHER;
}
@end