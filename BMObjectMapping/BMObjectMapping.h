//
//  BMObjectMapping.h
//  BMObjectMapping
//
//  Created by blackmilk on 13-7-19.
//  Copyright (c) 2013 blackmilk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMObjectMapping : NSObject

/**
* 是否允许下划线命名方式的键值自动映射,默认为NO
* 此时, 对于未配置的JSON key,会自动映射到与key名一致的属性名字上
* 如:  {"userName":"MyName"} 可自动映射到 User.userName属性
* 但是如果"userName"不采用驼峰命名而是下划线方式命名时:"user_name"
* 设置该属性为YES,也能进行自动转换
*/
@property(nonatomic, assign) BOOL enableUnderScoreKey;

+ (BMObjectMapping *)instance;

/**
*   映射转换, 由json转换为object
*   @param  jsonDict
*   @param  cls
*   @return  cls的实例
*/
- (id)mapFromJson:(NSDictionary *)jsonDict targetClass:(Class)cls;

/**
*  映射转换，将多个json转换为多个object
*  @param   array   json数组,内部应都为NSDictionary对象,每个dic映射为一个实体对象
*  @param   cls     映射目标对象类
*  @return          cls实例数组
*/
- (NSArray *)mapFromJsonArray:(NSArray *)array targetClass:(Class)cls;

@end
