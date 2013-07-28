//
// Created by blackmilk on 13-7-20.
//
// 
//


#import "BMObjectProperties.h"
#import "BMObjectProperty.h"


@implementation BMObjectProperties {
    NSMutableDictionary *_dicProperty;
    Class _targetClass;
}

@synthesize targetClass = _targetClass;

- (id)initWithClass:(Class)cls {
    self = [super init];
    if (self) {
        _dicProperty = [NSMutableDictionary dictionary];
        _targetClass = cls;

        [self loadProperties];
    }

    return self;
}

- (NSArray *)properties {
    return _dicProperty.allValues;
}

- (BMObjectProperty *)propertyOfName:(NSString *)name {
    return [_dicProperty objectForKey:name];
}

#pragma mark Private
- (void)loadProperties {
    unsigned int propsCount;
    objc_property_t *propList = class_copyPropertyList(_targetClass, &propsCount);

    for (int i = 0; i < propsCount; i++) {
        objc_property_t anObjcProp = propList[i];
        BMObjectProperty *property = [[BMObjectProperty alloc] initWithProp:anObjcProp];
        if (![self shouldIgnoreProperty:property]) {
            [_dicProperty setObject:property forKey:property.propertyName];
        }
    }

    if (propList) {
        free(propList);
    }
}

- (BOOL)shouldIgnoreProperty:(BMObjectProperty *)property {
    return property.isReadonly;
}
@end