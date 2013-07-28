//
// Created by blackmilk on 13-7-16.
//
// 
//


#import "BMNameMapper.h"
#import "NSDictionary+KeyPath.h"


@implementation BMNameMapper {

}

- (void)convertToTarget:(id)target fromJson:(NSDictionary *)json {
    NSString *key = self.keys[0];
    id value = [json objectForKeyPath:key];

    if (value != nil && ![value isKindOfClass:[NSNull class]]) {
        [self updateTarget:target withValue:value];
    }
}

@end