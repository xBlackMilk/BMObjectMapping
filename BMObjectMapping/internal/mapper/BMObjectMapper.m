//
// Created by blackmilk on 13-7-16.
//
// 
//


#import "BMObjectMapper.h"
#import "BMObjectMapping.h"
#import "NSDictionary+KeyPath.h"


@implementation BMObjectMapper {

@private
    Class _targetClass;
}


@synthesize targetClass = _targetClass;

- (id)initWithKey:(NSString *)key propertyName:(NSString *)name targetClass:(Class)cls {
    self = [super initWithKeys:@[key] propertyName:name];
    if (self) {
        _targetClass = cls;
    }

    return self;
}

- (void)convertToTarget:(id)target fromJson:(NSDictionary *)json {
    id value = [json objectForKeyPath:self.keys[0]];

    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        return;
    }


    if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = [[BMObjectMapping instance] mapFromJsonArray:value targetClass:self.targetClass];
        [self updateTarget:target withValue:array];
    } else if([value isKindOfClass:[NSDictionary class]]){
        id obj = [[BMObjectMapping instance] mapFromJson:value targetClass:self.targetClass];
        [self updateTarget:target withValue:obj];
    }
}


@end