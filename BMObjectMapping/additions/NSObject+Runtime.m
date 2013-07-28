//
// Created by blackmilk on 13-7-15.
//
// 
//


#import <objc/runtime.h>
#import "NSObject+Runtime.h"


@implementation NSObject (Runtime)

- (NSString *)className {
    return [NSString stringWithUTF8String:class_getName([self class])];
}

- (NSString *)debugDescription {
    NSMutableString *desc = [NSMutableString string];
    NSMutableArray *arrProps = [NSMutableArray array];

    Class cls = self.class;
    while (cls != [NSObject class]) {
        unsigned int propsCount;
        objc_property_t *propList = class_copyPropertyList(cls, &propsCount);
        for (int i = 0; i < propsCount; i++) {
            objc_property_t oneProp = propList[i];
            [arrProps addObject:[NSString stringWithUTF8String:property_getName(oneProp)]];
        }

        if (propList)
            free(propList);

        cls = class_getSuperclass(cls);
    }

    [desc appendFormat:@"<%@ %p", self.className, (__bridge void *) self];
    for (NSString *propName in arrProps) {
        [desc appendFormat:@",%@=%@", propName, [self valueForKey:propName]];
    }

    [desc appendString:@">"];
    return desc;
}


@end