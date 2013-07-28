//
// Created by blackmilk on 13-7-16.
//
// 
//


#import <Foundation/Foundation.h>


@interface BMMapper : NSObject

@property(nonatomic, strong) NSString *propertyName;
@property(nonatomic, strong) NSArray *keys;

- (id)initWithKeys:(NSArray *)keys propertyName:(NSString *)name;

- (void)convertToTarget:(id)target fromJson:(NSDictionary *)json;

- (void)updateTarget:(id)target withValue:(id)value;

@end