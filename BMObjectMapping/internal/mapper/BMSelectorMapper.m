//
// Created by blackmilk on 13-7-16.
//
// 
//


#import "BMSelectorMapper.h"
#import "NSObject+Runtime.h"
#import "NSDictionary+KeyPath.h"
#import "BMLog.h"


@implementation BMSelectorMapper {

@private
    id _target;
    SEL _selector;
}


@synthesize target = _target;
@synthesize selector = _selector;

- (id)initWithKeys:(NSArray *)keys propertyName:(NSString *)propertyName target:(id)target selector:(SEL)selector {
    self = [super initWithKeys:keys propertyName:propertyName];
    if (self) {
        _target = target;
        _selector = selector;
    }

    return self;
}


- (void)convertToTarget:(id)target fromJson:(NSDictionary *)json {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:self.keys.count];
    for (NSString *key in self.keys) {
        id value = [json objectForKeyPath:key];
        if (value == nil) {
            value = [NSNull null];
        }

        [params addObject:value];
    }

    if ([_target respondsToSelector:_selector]) {
        NSMethodSignature *signature = [_target methodSignatureForSelector:_selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:_target];
        [invocation setSelector:_selector];
        [invocation setArgument:&params atIndex:2];
        [invocation invoke];

        const char *returnType = signature.methodReturnType;

        if (returnType == NULL || returnType[0] == 'v') {
            BM_LOG_E(@"invalidate selector (cls:%@ sel:%@),the return type is null or void",
            [_target className],
            NSStringFromSelector(_selector));

        } else if (returnType[0] == '@') {
            id result;
            [invocation getReturnValue:&result];
            [self updateTarget:target withValue:result];
        } else {
            unsigned char bytes[signature.methodReturnLength];
            [invocation getReturnValue:bytes];

            NSValue *result = nil;
            if (returnType[0] == 'i') {
                int value;
                memcpy(&value, bytes, sizeof(int));
                result = [NSNumber numberWithInt:value];
            } else if (returnType[0] == 'I') {
                unsigned int value;
                memcpy(&value, bytes, sizeof(unsigned int));
                result = [NSNumber numberWithUnsignedInt:value];
            } else if (returnType[0] == 'c') {
                char value;
                memcpy(&value, bytes, sizeof(value));
                result = [NSNumber numberWithChar:value];
            } else if (returnType[0] == 'C') {
                unsigned char value;
                memcpy(&value, bytes, sizeof(value));
                result = [NSNumber numberWithUnsignedChar:value];
            } else if (returnType[0] == 's') {
                short value;
                memcpy(&value, bytes, sizeof(value));
                result = [NSNumber numberWithShort:value];
            } else if (returnType[0] == 'S') {
                unsigned short value;
                memcpy(&value, bytes, sizeof(value));
                result = [NSNumber numberWithUnsignedShort:value];
            } else if (returnType[0] == 'l') {
                long value;
                memcpy(&value, bytes, sizeof(value));
                result = [NSNumber numberWithLong:value];
            } else if (returnType[0] == 'L') {
                unsigned long value;
                memcpy(&value, bytes, sizeof(value));
                result = [NSNumber numberWithUnsignedLong:value];
            } else if (returnType[0] == 'q') {
                long long value;
                memcpy(&value, bytes, sizeof(value));
                result = [NSNumber numberWithLongLong:value];
            } else if (returnType[0] == 'Q') {
                unsigned long long value;
                memcpy(&value, bytes, sizeof(value));
                result = [NSNumber numberWithUnsignedLongLong:value];
            } else if (returnType[0] == 'f') {
                float value;
                memcpy(&value, bytes, sizeof(value));
                result = [NSNumber numberWithFloat:value];
            } else if (returnType[0] == 'd') {
                double value;
                memcpy(&value, bytes, sizeof(value));
                result = [NSNumber numberWithDouble:value];
            } else if (returnType[0] == 'B') {
                bool value;
                memcpy(&value, bytes, sizeof(value));
                result = [NSNumber numberWithBool:value];
            } else {
                result = [[NSValue alloc] initWithBytes:bytes objCType:[signature methodReturnType]];
            }

            [self updateTarget:target withValue:result];
        }
    } else {
        BM_LOG_E(@"target '%@' cant response selector '%@' ", [_target className], NSStringFromSelector(_selector));
    }


}


@end