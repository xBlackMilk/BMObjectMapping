//
// Created by blackmilk on 13-7-20.
//
// 
//


#import "BMObjectPropertyHolder.h"
#import "BMObjectProperty.h"
#import "BMObjectProperties.h"


@implementation BMObjectPropertyHolder {
    dispatch_queue_t _lockQueue;
    NSMutableDictionary *_dicProperties;

}

+ (BMObjectPropertyHolder *)instance {
    static BMObjectPropertyHolder *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _lockQueue = dispatch_queue_create([[NSString stringWithFormat:@"property_holder.%@", self] UTF8String], DISPATCH_QUEUE_SERIAL);
        _dicProperties = [NSMutableDictionary dictionary];
    }

    return self;
}

- (BMObjectProperty *)propertyOfClass:(Class)cls propertyName:(NSString *)name {
    BMObjectProperties *properties = [self propertiesOfClass:cls];
    return [properties propertyOfName:name];
}

- (BMObjectProperties *)propertiesOfClass:(Class)cls {
    return [self holdPropertiesOfClass:cls];
}

#pragma mark Private

- (BMObjectProperties *)holdPropertiesOfClass:(Class)cls {
    NSString *clsName = [cls className];
    __block BMObjectProperties *properties = nil;

    [self executeLocked:^() {
        if ([_dicProperties objectForKey:clsName]) {
            properties = [_dicProperties objectForKey:clsName];
        } else {
            properties = [[BMObjectProperties alloc] initWithClass:cls];
            [_dicProperties setObject:properties forKey:clsName];
        }
    }];

    return properties;
}

- (void)executeLocked:(void (^)(void))aBlock {
    dispatch_sync(_lockQueue, aBlock);
}
@end