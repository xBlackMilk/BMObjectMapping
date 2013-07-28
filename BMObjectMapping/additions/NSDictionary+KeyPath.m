//
// Created by blackmilk on 13-7-22.
//
// 
//


#import "NSDictionary+KeyPath.h"


@implementation NSDictionary (KeyPath)

- (id)objectForKeyPath:(NSString *)keyPath {
    NSAssert(keyPath != nil, @"keyPath不能为nil");

    if ([keyPath rangeOfString:@"."].location == NSNotFound) {
        return [self objectForKey:keyPath];
    }

    NSArray *keys = [keyPath componentsSeparatedByString:@"."];
    if (keys.count > 1) {
        NSDictionary *dic = self;
        for (int idx = 0; idx < keys.count - 1; idx++) {
            id value = dic[keys[(NSUInteger) idx]];
            if (value == nil || [value isKindOfClass:[NSNull class]]) {
                return nil;
            }

            if (![value isKindOfClass:[NSDictionary class]]) {
                BM_LOG_W(@"keypath:(%@) 取值错误, %@字段不为dic类型, json:%@", keyPath, keys[(NSUInteger) idx], self);
                return nil;
            }

            dic = value;
        }

        return dic[keys.lastObject];
    } else {
        return [self objectForKey:keyPath];
    }
}


@end