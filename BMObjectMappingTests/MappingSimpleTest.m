//
// Created by blackmilk on 13-7-20.
//
// 
//


#import <CoreLocation/CoreLocation.h>
#import "MappingSimpleTest.h"
#import "Student.h"
#import "BMObjectMapping.h"
#import "Address.h"
#import "BMObjectPropertyHolder.h"
#import "BMObjectProperty.h"


@implementation MappingSimpleTest {

}

- (void)test {
    NSDictionary *student = @{@"name" : @"myName",
            @"birthday" : @32030292,
            @"address" : @{
                    @"cityId" : @100,
                    @"cityName" : @"北京",
                    @"latitude":@100,
                    @"longitude":@200,
                    @"t1":@100,
                    @"t2":@200


            }};


    BMObjectProperty *property = [[BMObjectPropertyHolder instance] propertyOfClass:[Address class] propertyName:@"location"];
    NSLog(@"loc prop:%@", [property typeName]);

    Student *obj = [[BMObjectMapping instance] mapFromJson:student targetClass:[Student class]];
    STAssertEqualObjects(obj.name, @"myName", @"隐射name属性失败");
    STAssertEquals(obj.cityId, 100, @"隐射address.cityId属性失败");
    STAssertEqualObjects(obj.address.cityName, @"北京", @"映射address.cityName属性失败");
    STAssertEquals(obj.address.cityId, 100, @"映射address.cityId属性失败");
    STAssertEquals(obj.address.testSel, 100, @"映射address.testSel");
//    STAssertEquals((int) [obj.birthday timeIntervalSince1970], 32030292, @"映射address.birthday属性失败");
    NSLog(@"%f",obj.address.location.latitude);




}


@end