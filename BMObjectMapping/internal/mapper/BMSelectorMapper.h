//
// Created by blackmilk on 13-7-16.
//
// 
//


#import "BMMapper.h"


@interface BMSelectorMapper : BMMapper

@property(nonatomic, strong) id target;
@property(nonatomic, assign) SEL selector;

- (id)initWithKeys:(NSArray *)keys
      propertyName:(NSString *)propertyName
            target:(id)target
          selector:(SEL)selector;

@end