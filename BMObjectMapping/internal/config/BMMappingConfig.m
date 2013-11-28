//
// Created by blackmilk on 13-7-20.
//
// 
//


#import "BMMappingConfig.h"
#import "BMMappingConfigParser.h"
#import "BMMapper.h"
#import "BMLog.h"


@implementation BMMappingConfig {
    NSMutableSet *_keySet;
    NSMutableArray *_converters;
}

- (id)init {
    self = [super init];
    if (self) {
        _keySet = [NSMutableSet set];
        _converters = [NSMutableArray array];
    }

    return self;
}

- (BOOL)loadFromFile:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data == nil) {
        return NO;
    }

    BMMappingConfigParser *parser = [[BMMappingConfigParser alloc] initWithData:data];
    parser.NewConverterBlock = ^(BMMapper *converter) {
        [_converters addObject:converter];
        [_keySet addObjectsFromArray:converter.keys];
    };
    parser.ParseLineFailedBlock = ^(NSString *lineContent) {
        BM_LOG_W(@"无法解析的配置内容:%@", lineContent);
    };

    [parser parse];
    return YES;
}

@end