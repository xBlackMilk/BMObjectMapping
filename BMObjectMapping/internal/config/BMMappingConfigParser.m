//
// Created by blackmilk on 13-7-20.
//
// 
//


#import "BMMappingConfigParser.h"
#import "BMMapper.h"
#import "BMSelectorMapper.h"
#import "BMObjectMapper.h"
#import "BMIgnoredKeyMapper.h"
#import "BMNameMapper.h"
#import "BMLog.h"

#define kSelectorConverterPattern     @"^.+:.+=\\s*\\[\\s*\\w+\\s+\\w+\\s*\\]$"
#define kIgnoredConverterPattern      @"^.+:\\s*#$"
#define kObjectConverterPattern       @"^.+:\\s*\\w+\\s*@\\s*\\w+$"
#define kNameConverterPattern         @"^[\\w\\.]+\\s*:\\s*\\w+$"

static NSRegularExpression *selectorRegex = nil;
static NSRegularExpression *ignoredRegex = nil;
static NSRegularExpression *objectRegex = nil;
static NSRegularExpression *nameRegex = nil;

@implementation BMMappingConfigParser {
    NSData *_data;
}

+ (void)initialize {
    [super initialize];

    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSError *error = nil;
        selectorRegex = [NSRegularExpression regularExpressionWithPattern:kSelectorConverterPattern options:0 error:&error];
        ignoredRegex = [NSRegularExpression regularExpressionWithPattern:kIgnoredConverterPattern options:0 error:&error];
        objectRegex = [NSRegularExpression regularExpressionWithPattern:kObjectConverterPattern options:0 error:&error];
        nameRegex = [NSRegularExpression regularExpressionWithPattern:kNameConverterPattern options:0 error:&error];
    });
}


- (id)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}

- (void)parse {
    NSArray *lines = [self allLines];
    for (NSString *line in lines) {
        [self parseLine:line];
    }
}

#pragma mark Private

- (NSArray *)allLines {
    NSString *content = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    return [content componentsSeparatedByString:@"\n"];
}

- (void)parseLine:(NSString *)line {
    //trim
    line = [line stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
    if (line.length == 0) {
        return;
    }

    BMMapper *converter = nil;

    if ([self isMatchedRegex:selectorRegex forString:line]) {//match selector mapping
        converter = [self parseSelectorConverterFromLine:line];
    } else if ([self isMatchedRegex:objectRegex forString:line]) {//match object mapping
        converter = [self parseObjectConverterFromLine:line];
    } else if ([self isMatchedRegex:ignoredRegex forString:line]) {//match ignored mapping
        converter = [self parseIgnoredConverterFromLine:line];
    } else if ([self isMatchedRegex:nameRegex forString:line]) {//match name mapping
        converter = [self parseNameConverterFromLine:line];
    }

    if (converter != nil) {
        if (self.NewConverterBlock) {
            self.NewConverterBlock(converter);
        }
    } else {
        //parse line failed
        if (self.ParseLineFailedBlock) {
            self.ParseLineFailedBlock(line);
        }
    }
}

- (BMSelectorMapper *)parseSelectorConverterFromLine:(NSString *)line {
    BM_LOG_D(@"parse SelectorMapper from conf line:%@", line);

    NSString *element = nil;
    NSScanner *scanner = [NSScanner scannerWithString:line];

    NSMutableArray *keys = nil;
    if ([scanner scanUpToString:@":" intoString:&element]) {
        // scan到 ”:“, 内容为json Key列表,以为","分割
        //分割后，需要进行trim处理
        keys = [NSMutableArray arrayWithArray:[element componentsSeparatedByString:@","]];
        for (NSInteger idx = 0; idx < keys.count; idx++) {
            NSString *aKey = [keys[(NSUInteger) idx] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (aKey.length == 0) {
                [keys removeObjectAtIndex:(NSUInteger) idx];
                idx--;
            } else {
                keys[(NSUInteger) idx] = aKey;
            }
        }
        if (keys.count == 0) {
            return nil;
        }

        [scanner scanString:@":" intoString:&element];
    } else {
        return nil;
    }


    NSString *propertyName = nil;
    NSString *targetName = nil;
    NSString *selectorName = nil;

    //scan到"=", 内容为property name
    if ([scanner scanUpToString:@"=" intoString:&element]) {
        propertyName = [element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [scanner scanString:@"=" intoString:&element];
    } else {
        return nil;
    }


    //scan到"[",之后为target name
    [scanner scanUpToString:@"[" intoString:&element];
    [scanner scanString:@"[" intoString:&element];

    if ([scanner scanUpToString:@" " intoString:&element]) {
        targetName = [element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [scanner scanString:@" " intoString:&element];
    } else {
        return nil;
    }

    //scan到"]",为selector name
    if ([scanner scanUpToString:@"]" intoString:&element]) {
        selectorName = [element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else {
        return nil;
    }

    id target = NSClassFromString(targetName);
    SEL selector = NSSelectorFromString(([NSString stringWithFormat:@"%@:", selectorName]));

    if (target == nil) {
        BM_LOG_W(@"未找到Class :%@", targetName);
        return nil;
    }

    if (selector == nil) {
        BM_LOG_W(@"转换SEL失败 :%@", selectorName);
        return nil;
    }

    BM_LOG_D(@"parse SelectorMapper result,keys:%@, propName:%@ target:%@ sel:%@", keys, propertyName, targetName, selectorName);
    return [[BMSelectorMapper alloc] initWithKeys:keys propertyName:propertyName target:target selector:selector];
}

- (BMMapper *)parseObjectConverterFromLine:(NSString *)line {
    BM_LOG_D(@"parse ObjectMapper from conf line:%@", line);

    NSString *element = nil;
    NSScanner *scanner = [NSScanner scannerWithString:line];

    NSString *key = nil;
    NSString *propertyName = nil;
    NSString *targetClassName = nil;

    // scan到 ”:“, 获取key
    if ([scanner scanUpToString:@":" intoString:&element]) {
        key = [element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [scanner scanString:@":" intoString:&element];
    } else {
        return nil;
    }

    //scan到"@",获取property name
    if ([scanner scanUpToString:@"@" intoString:&element]) {
        propertyName = [element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [scanner scanString:@"@" intoString:&element];
    } else {
        return nil;
    }

    //scan获取剩余的class name
    if ([scanner scanUpToString:@"" intoString:&element]) {
        targetClassName = [element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else {
        return nil;
    }

    BM_LOG_D(@"parse ObjectMapper result,key=%@ propName=%@ clsName=%@", key, propertyName, targetClassName);

    Class targetClass = NSClassFromString(targetClassName);
    if (key.length == 0 || propertyName.length == 0 || targetClass == nil) {
        return nil;
    }

    return [[BMObjectMapper alloc] initWithKey:key propertyName:propertyName targetClass:targetClass];
}

- (BMMapper *)parseIgnoredConverterFromLine:(NSString *)line {
    BM_LOG_D(@"parse IgnoredKeyMapper from conf line:%@", line);

    NSString *element = nil;
    NSScanner *scanner = [NSScanner scannerWithString:line];

    NSString *key = nil;

    // scan到 ”:“, 获取key
    if ([scanner scanUpToString:@":" intoString:&element]) {
        key = [element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [scanner scanString:@":" intoString:&element];
    } else {
        return nil;
    }

    if (key.length == 0) {
        return nil;
    }

    BM_LOG_D(@"parse IgnoredKeyMapper result, key:%@", key);
    return [[BMIgnoredKeyMapper alloc] initWithKeys:@[key] propertyName:nil];
}

- (BMMapper *)parseNameConverterFromLine:(NSString *)line {
    BM_LOG_D(@"parse NameMapper from conf line:%@", line);

    NSString *element = nil;
    NSScanner *scanner = [NSScanner scannerWithString:line];

    NSString *key = nil;
    NSString *propertyName = nil;

    // scan到 ”:“, 获取key
    if ([scanner scanUpToString:@":" intoString:&element]) {
        key = [element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [scanner scanString:@":" intoString:&element];
    } else {
        return nil;
    }

    //scan其他的获取property name
    if ([scanner scanUpToString:@"" intoString:&element]) {
        propertyName = [element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else {
        return nil;
    }

    if (key.length == 0 || propertyName.length == 0) {
        return nil;
    }

    BM_LOG_D(@"parse NameMappe result,key :%@ prop:%@", key, propertyName);
    return [[BMNameMapper alloc] initWithKeys:@[key] propertyName:propertyName];
}


- (BOOL)isMatchedRegex:(NSRegularExpression *)regex forString:(NSString *)string {
    NSTextCheckingResult *firstMatch = [regex firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
    return firstMatch != nil;
}

@end