//
// Created by blackmilk on 13-7-20.
//
// 
//


#import <Foundation/Foundation.h>

@class BMMapper;


@interface BMMappingConfigParser : NSObject

@property(nonatomic, copy) void  (^NewConverterBlock)(BMMapper *converter);
@property(nonatomic, copy) void  (^ParseLineFailedBlock)(NSString *lineContent);

- (id)initWithData:(NSData *)data;

- (void)parse;

@end