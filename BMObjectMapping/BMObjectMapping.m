//
//  BMObjectMapping.m
//  BMObjectMapping
//
//  Created by blackmilk on 13-7-19.
//  Copyright (c) 2013 blackmilk. All rights reserved.
//

#import "BMObjectMapping.h"
#import "BMMappingConfig.h"
#import "BMMapper.h"
#import "BMNameMapper.h"
#import "NSObject+Runtime.h"
#import "BMObjectPropertyHolder.h"
#import "BMObjectProperty.h"
#import "BMObjectMapper.h"
#import "BMLog.h"

@implementation BMObjectMapping {
    //key: class name, value:EntityConfig
    NSMutableDictionary *_mappingConfigDic;

    dispatch_queue_t _queue;
    BOOL _enableUnderScoreKey;
}


@synthesize enableUnderScoreKey = _enableUnderScoreKey;

+ (BMObjectMapping *)instance {
    static BMObjectMapping *_instance = nil;
    static dispatch_once_t once;

    dispatch_once(&once, ^() {
        _instance = [[self alloc] init];
    });

    return _instance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.enableUnderScoreKey = NO;
        _mappingConfigDic = [NSMutableDictionary dictionary];
        _queue = dispatch_queue_create("objectmapping.cachequeue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (id)mapFromJson:(NSDictionary *)jsonDict targetClass:(Class)cls {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:jsonDict];
    id target = [[cls alloc] init];

    [self mapUsingConfigFromJson:dic toTarget:target];
    [self mapUsingDefaultFromJson:dic toTarget:target];

    return target;
}

- (NSArray *)mapFromJsonArray:(NSArray *)array targetClass:(Class)cls {
    NSAssert(array != nil, @"param 'array' cant be nil");

    NSMutableArray *arrObjects = [NSMutableArray array];
    for (NSDictionary *jsonDic in array) {
        id object = [self mapFromJson:jsonDic targetClass:cls];
        if (object != nil) {
            [arrObjects addObject:object];
        }
    }
    return arrObjects;
}


#pragma mark Mapping from config

/**
* 由类名载入对应的配置文件信息
* 根据配置信息进行隐射转换
*/
- (void)mapUsingConfigFromJson:(NSMutableDictionary *)json toTarget:(id)target {
    BMMappingConfig *config = [self configOfEntity:[target class]];
    if (config == nil || [config isKindOfClass:[NSNull class]]) {
        return;
    }

    for (BMMapper *mapper in config.converters) {
        [mapper convertToTarget:target fromJson:json];
    }

    [json removeObjectsForKeys:config.keySet.allObjects];
}

- (BMMappingConfig *)configOfEntity:(Class)cls {
    BMMappingConfig *config = [self queryConfigOfClass:cls];
    if (config == nil) {
        [self loadConfigOfClass:cls];
        config = [self queryConfigOfClass:cls];
    }

    return config;
}

- (BMMappingConfig *)queryConfigOfClass:(Class)cls {
    NSString *clsName = [cls className];
    __block id result = nil;

    dispatch_sync(_queue, ^() {
        if ([_mappingConfigDic objectForKey:clsName]) {
            result = [_mappingConfigDic objectForKey:clsName];
        }
    });

    return result;
}

- (void)loadConfigOfClass:(Class)cls {
    NSString *clsName = [cls className];
    dispatch_barrier_async(_queue, ^() {
        if ([_mappingConfigDic objectForKey:clsName]) {
            return;
        }

        NSBundle *myBundle = [NSBundle bundleForClass:[self class]];
        NSString *configFilePath = [myBundle pathForResource:clsName ofType:@"om"];

        if ([[NSFileManager defaultManager] fileExistsAtPath:configFilePath]) {
            BMMappingConfig *config = [[BMMappingConfig alloc] init];
            if ([config loadFromFile:configFilePath]) {
                [_mappingConfigDic setObject:config forKey:clsName];
            }
        } else {
            BM_LOG_W(@"file not exist:%@", configFilePath);
            [_mappingConfigDic setObject:[NSNull null] forKey:clsName];
        }
    });
}

#pragma mark Mapping Default
- (void)mapUsingDefaultFromJson:(NSMutableDictionary *)json toTarget:(id)target {
    BMNameMapper *nameMapper = [[BMNameMapper alloc] initWithKeys:nil propertyName:nil];
    BMObjectMapper *objectMapper = [[BMObjectMapper alloc] initWithKeys:nil propertyName:nil];

    for (NSString *key in json.allKeys) {
        BMObjectProperty *property = [self getPropertyNameOfTargetClass:[target class] forKey:key];
        if (property == nil) {
            BM_LOG_W(@"转换%@时,未能映射key:%@ keys:%@", [target className], key, json.allKeys);
            continue;
        }

        BMMapper *mapper = nil;
        if ([json[key] isKindOfClass:[NSDictionary class]] && property.isOtherType) {
            //转换为对象
            objectMapper.targetClass = NSClassFromString(property.typeName);
            mapper = objectMapper;
        } else {
            //属性转换
            mapper = nameMapper;
        }

        mapper.keys = @[key];
        mapper.propertyName = property.propertyName;
        [mapper convertToTarget:target fromJson:json];
    }
}

- (BMObjectProperty *)getPropertyNameOfTargetClass:(Class)cls  forKey:(NSString *)key {
    BMObjectProperty *property = [[BMObjectPropertyHolder instance] propertyOfClass:cls propertyName:key];

    if (property == nil &&
            self.enableUnderScoreKey &&
            [key rangeOfString:@"_"].location != NSNotFound) {
        key = [self changeUnderscore2CamelCase:key];
        property = [[BMObjectPropertyHolder instance] propertyOfClass:cls propertyName:key];
    }

    return property;
}

- (NSString *)changeUnderscore2CamelCase:(NSString *)content {
    unichar data[content.length + 1];
    int pos = 0;
    BOOL needUpper = NO;

    for (int idx = 0; idx < content.length; idx++) {
        if ([content characterAtIndex:(NSUInteger) idx] == '_') {
            needUpper = YES;
            continue;
        } else {
            if (needUpper) {
                data[pos++] = (unichar) toupper([content characterAtIndex:(NSUInteger) idx]);
                needUpper = NO;
            } else {
                data[pos++] = [content characterAtIndex:(NSUInteger) idx];
            }
        }
    }
    data[pos] = 0;

    BM_LOG_D(@"下划线命名%@ -> 驼峰命名:%@", content, [[NSString alloc] initWithCharacters:data length:(NSUInteger) pos]);
    return [[NSString alloc] initWithCharacters:data length:(NSUInteger) pos];
}


@end
