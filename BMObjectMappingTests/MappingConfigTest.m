//
// Created by blackmilk on 13-7-20.
//
// 
//


#import "MappingConfigTest.h"
#import "BMMappingConfig.h"
#import "BMIgnoredKeyMapper.h"
#import "BMNameMapper.h"
#import "BMObjectMapper.h"
#import "Address.h"
#import "BMSelectorMapper.h"
#import "MyMapper.h"


@implementation MappingConfigTest {

}

- (void)testEmptyConfig {
    NSBundle *myBundle = [NSBundle bundleForClass:[self class]];
    NSString *configFilePath = [myBundle pathForResource:@"empty" ofType:@"om"];

    BMMappingConfig *config = [[BMMappingConfig alloc] init];
    [config loadFromFile:configFilePath];

    STAssertTrue(config.keySet.count == 0, @"解析空的配置文件错误，keySet不为空:%@", config.keySet);
    STAssertTrue(config.converters.count == 0, @"解析空的配置文件错误，mapper不为空:%@", config.converters);
}

- (void)testNormalConfig {
    NSBundle *myBundle = [NSBundle bundleForClass:[self class]];
    NSString *configFilePath = [myBundle pathForResource:@"conf_without_error" ofType:@"om"];

    BMMappingConfig *config = [[BMMappingConfig alloc] init];
    [config loadFromFile:configFilePath];

    STAssertTrue(config.keySet.count == 19, @"解析配置文件错误，keySet数据与预期不一致:%@", config.keySet);

    //name mapper
    BMNameMapper *nameMapper = config.converters[0];
    STAssertEqualObjects(nameMapper.keys[0], @"key_name1", @"name映射属性解析失败");
    STAssertEqualObjects(nameMapper.propertyName, @"prop_name1", @"name映射属性解析失败");
    nameMapper = config.converters[1];
    STAssertEqualObjects(nameMapper.keys[0], @"key_name2", @"name映射属性解析失败");
    STAssertEqualObjects(nameMapper.propertyName, @"prop_name2", @"name映射属性解析失败");
    nameMapper = config.converters[2];
    STAssertEqualObjects(nameMapper.keys[0], @"key_name3", @"name映射属性解析失败");
    STAssertEqualObjects(nameMapper.propertyName, @"prop_name3", @"name映射属性解析失败");
    nameMapper = config.converters[3];
    STAssertEqualObjects(nameMapper.keys[0], @"key_name4", @"name映射属性解析失败");
    STAssertEqualObjects(nameMapper.propertyName, @"prop_name4", @"name映射属性解析失败");

    //ignored
    BMIgnoredKeyMapper *ignoredKeyMapper = config.converters[4];
    STAssertEqualObjects(ignoredKeyMapper.keys[0], @"unused1", @"Ignored属性解析失败");
    STAssertEqualObjects(ignoredKeyMapper.propertyName, nil, @"Ignored属性解析失败");

    ignoredKeyMapper = config.converters[5];
    STAssertEqualObjects(ignoredKeyMapper.keys[0], @"unused2", @"Ignored属性解析失败");
    STAssertEqualObjects(ignoredKeyMapper.propertyName, nil, @"Ignored属性解析失败");

    ignoredKeyMapper = config.converters[6];
    STAssertEqualObjects(ignoredKeyMapper.keys[0], @"unused3", @"Ignored属性解析失败");
    STAssertEqualObjects(ignoredKeyMapper.propertyName, nil, @"Ignored属性解析失败");

    //obj
    BMObjectMapper *objectMapper = config.converters[7];
    STAssertEqualObjects(objectMapper.keys[0], @"key_obj1", @"Object映射属性解析失败");
    STAssertEqualObjects(objectMapper.propertyName, @"prop_obj", @"Object映射属性解析失败");
    STAssertEqualObjects(objectMapper.targetClass, [Address class], @"Object映射属性解析失败");

    objectMapper = config.converters[8];
    STAssertEqualObjects(objectMapper.keys[0], @"key_obj2", @"Object映射属性解析失败");
    STAssertEqualObjects(objectMapper.propertyName, @"prop_obj", @"Object映射属性解析失败");
    STAssertEqualObjects(objectMapper.targetClass, [Address class], @"Object映射属性解析失败");

    objectMapper = config.converters[9];
    STAssertEqualObjects(objectMapper.keys[0], @"key_obj3", @"Object映射属性解析失败");
    STAssertEqualObjects(objectMapper.propertyName, @"prop_obj", @"Object映射属性解析失败");
    STAssertEqualObjects(objectMapper.targetClass, [Address class], @"Object映射属性解析失败");

    objectMapper = config.converters[10];
    STAssertEqualObjects(objectMapper.keys[0], @"key_obj4", @"Object映射属性解析失败");
    STAssertEqualObjects(objectMapper.propertyName, @"prop_obj", @"Object映射属性解析失败");
    STAssertEqualObjects(objectMapper.targetClass, [Address class], @"Object映射属性解析失败");

    objectMapper = config.converters[11];
    STAssertEqualObjects(objectMapper.keys[0], @"key_obj5", @"Object映射属性解析失败");
    STAssertEqualObjects(objectMapper.propertyName, @"prop_obj", @"Object映射属性解析失败");
    STAssertEqualObjects(objectMapper.targetClass, [Address class], @"Object映射属性解析失败");

    //sel
    BMSelectorMapper *selectorMapper = config.converters[12];
    STAssertEqualObjects(selectorMapper.keys[0], @"key_sel1", @"Selector映射属性解析失败");
    STAssertEqualObjects(selectorMapper.propertyName, @"prop_sel", @"Selector映射属性解析失败");
    STAssertEqualObjects(selectorMapper.target, [MyMapper class], @"Selector映射属性解析失败");
    STAssertEqualObjects(NSStringFromSelector(selectorMapper.selector), @"myselector:", @"Selector映射属性解析失败");

    selectorMapper = config.converters[13];
    STAssertEqualObjects(selectorMapper.keys[0], @"key_sel2", @"Selector映射属性解析失败");
    STAssertEqualObjects(selectorMapper.propertyName, @"prop_sel", @"Selector映射属性解析失败");
    STAssertEqualObjects(selectorMapper.target, [MyMapper class], @"Selector映射属性解析失败");
    STAssertEqualObjects(NSStringFromSelector(selectorMapper.selector), @"myselector:", @"Selector映射属性解析失败");

    selectorMapper = config.converters[14];
    STAssertEqualObjects(selectorMapper.keys[0], @"key_sel3", @"Selector映射属性解析失败");
    STAssertEqualObjects(selectorMapper.propertyName, @"prop_sel", @"Selector映射属性解析失败");
    STAssertEqualObjects(selectorMapper.target, [MyMapper class], @"Selector映射属性解析失败");
    STAssertEqualObjects(NSStringFromSelector(selectorMapper.selector), @"myselector:", @"Selector映射属性解析失败");

    selectorMapper = config.converters[15];
    STAssertEqualObjects(selectorMapper.keys[0], @"key_sel4", @"Selector映射属性解析失败");
    STAssertEqualObjects(selectorMapper.keys[1], @"key_sel5", @"Selector映射属性解析失败");
    STAssertEqualObjects(selectorMapper.propertyName, @"prop_sel", @"Selector映射属性解析失败");
    STAssertEqualObjects(selectorMapper.target, [MyMapper class], @"Selector映射属性解析失败");
    STAssertEqualObjects(NSStringFromSelector(selectorMapper.selector), @"myselector:", @"Selector映射属性解析失败");


    selectorMapper = config.converters[16];
    STAssertEqualObjects(selectorMapper.keys[0], @"key_sel6", @"Selector映射属性解析失败");
    STAssertEqualObjects(selectorMapper.keys[1], @"key_sel7", @"Selector映射属性解析失败");
    STAssertEqualObjects(selectorMapper.propertyName, @"prop_sel", @"Selector映射属性解析失败");
    STAssertEqualObjects(selectorMapper.target, [MyMapper class], @"Selector映射属性解析失败");
    STAssertEqualObjects(NSStringFromSelector(selectorMapper.selector), @"myselector:", @"Selector映射属性解析失败");

    selectorMapper = config.converters[17];
    STAssertEqualObjects(selectorMapper.keys[0], @"key_sel6", @"Selector映射属性解析失败");
    STAssertEqualObjects(selectorMapper.keys[1], @"key_sel7", @"Selector映射属性解析失败");
    STAssertEqualObjects(selectorMapper.propertyName, @"prop_sel", @"Selector映射属性解析失败");
    STAssertEqualObjects(selectorMapper.target, [MyMapper class], @"Selector映射属性解析失败");
    STAssertEqualObjects(NSStringFromSelector(selectorMapper.selector), @"myselector:", @"Selector映射属性解析失败");
}

@end