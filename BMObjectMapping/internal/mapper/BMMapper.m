//
// Created by blackmilk on 13-7-16.
//
// 
//


#import "BMMapper.h"
#import "BMObjectPropertyHolder.h"
#import "BMObjectProperty.h"
#import "NSObject+Runtime.h"


@implementation BMMapper {

@private
    NSString *_propertyName;
    NSArray *_keys;

    NSNumberFormatter *_numberFormatter;
}


@synthesize propertyName = _propertyName;
@synthesize keys = _keys;


- (id)initWithKeys:(NSArray *)keys propertyName:(NSString *)name {
    self = [super init];
    if (self) {
        _propertyName = name;
        _keys = keys;
        _numberFormatter = [[NSNumberFormatter alloc] init];
    }
    return self;
}

- (void)convertToTarget:(id)target fromJson:(NSDictionary *)json {


}

- (void)updateTarget:(id)target withValue:(id)value {
    BM_LOG_D(@"update target %@,prop name:%@ value:%@", [target className], self.propertyName, value);

    BMObjectProperty *property = [[BMObjectPropertyHolder instance] propertyOfClass:[target class] propertyName:self.propertyName];
    if (property != nil) {
        id convertedValue = [self convertValue:value withProperty:property];
        if (convertedValue == nil && ![value isKindOfClass:[NSNull class]]) {
            BM_LOG_E(@"%@ found dismatched type, value type(''%@) & prop type('%@')",
            [target className],
            [value className],
            property.typeName);
        }

        [target setValue:convertedValue forKey:self.propertyName];
    } else {
        BM_LOG_W(@"not fount prop '%@' in %@", self.propertyName, [target className]);
    }
}

- (id)convertValue:(id)value withProperty:(BMObjectProperty *)property {
    if ([value isKindOfClass:[NSNull class]]) {
        return nil;
    }

    if (property.isUrl) {
        if ([value isKindOfClass:[NSString class]]) {
            return [NSURL URLWithString:value];
        } else {
            return [NSURL URLWithString:[NSString stringWithFormat:@"%@", value]];
        }
    }
    else if (property.isString) {
        if ([value isKindOfClass:[NSString class]]) {
            return value;
        } else {
            return [NSString stringWithFormat:@"%@", value];
        }
    } else if (property.isNumber) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return value;
        } else if ([value isKindOfClass:[NSString class]]) {
            return [_numberFormatter numberFromString:value];
        }
    } else if (property.isDate) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        }
    } else if (property.isArray) {
        if ([value isKindOfClass:[NSArray class]]) {
            return value;
        }
    } else if (property.isSet) {
        if ([value isKindOfClass:[NSArray class]]) {
            return [NSSet setWithArray:value];
        }
    } else if (property.isDictionary) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            return value;
        }
    } else {
        return value;
    }

    return nil;
}

@end