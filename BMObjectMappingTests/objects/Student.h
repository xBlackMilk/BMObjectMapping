//
// Created by blackmilk on 13-7-20.
//
// 
//


#import <Foundation/Foundation.h>

@class Address;


@interface Student : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) NSDate *birthday;
@property(nonatomic, strong) NSURL *headImageUrl;
@property(nonatomic, strong) Address *address;
@property(nonatomic, strong) NSArray *teachers;
@property(nonatomic, assign) NSInteger cityId;

@end