//
//  MemoryObjectRequest.m
//  MemoryGraph
//
//  Created by David Grigoryan on 22.10.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import "MemoryObjectRequest.h"
#import "MemoryObject.h"
#import "NSObject+Collection.h"
#import <objc/message.h>
#import "MemoryReader.h"

@interface MemoryObjectRequest ()

@property (weak, nonatomic) MemoryReader *memoryReader;

@end

@implementation MemoryObjectRequest

- (instancetype)initWithMemoryReader:(MemoryReader *)memoryReader
{
    self = [super init];
    if (self) {
        _memoryReader = memoryReader;
    }
    return self;
}

- (NSArray<MemoryObject *> *)memoryObjectsFromValue:(const __unsafe_unretained id)value
                                               ivar:(Ivar)ivar {
    __unsafe_unretained id ivarValue = object_getIvar(value, ivar);
    NSString *fieldName = [NSString stringWithUTF8String:ivar_getName(ivar)];
    NSArray<MemoryObject *> *memoryObjects = [self memoryObjectsFromValue:&ivarValue fieldName:fieldName];
    return memoryObjects;
}

- (NSArray<MemoryObject *> *)memoryObjectsFromValue:(const __unsafe_unretained id)value
                                     property:(objc_property_t)property {
    NSString *propertyName = @(property_getName(property));
    SEL propertyGetter = NSSelectorFromString(propertyName);
    __unsafe_unretained id propertyValue = ((id(*)(id, SEL))objc_msgSend)(value, propertyGetter);
    NSArray<MemoryObject *> *memoryObjects = [self memoryObjectsFromValue:&propertyValue fieldName:propertyName];
    return memoryObjects;
}


#pragma mark - Private

- (NSArray<MemoryObject *> *)memoryObjectsFromValue:(const __unsafe_unretained id *)value
                                           fieldName:(NSString *)fieldName {
    void *ivarAddress = (__bridge void *) *value;
    if (!value) {
        return @[];
    }
    if (![self.memoryReader isPermittedCocoaObject:ivarAddress]) {
        return @[];
    }
    NSString *ivarClassName = @(object_getClassName(*value));
    if ([*value isCollection]) {
        NSArray<MemoryObject *> *flattenCollection = [self memoryObjectsFromCollection:*value ivarName:fieldName];
        if (flattenCollection) {
            return flattenCollection;
        }
    }
    
    MemoryObject *retainedObject = [[MemoryObject alloc] initWithClassName:ivarClassName
                                                             memoryAddress:ivarAddress
                                                                  ivarName:fieldName];
    return @[retainedObject];
}

- (NSArray<MemoryObject *> *)memoryObjectsFromCollection:(const __unsafe_unretained id)collection
                                                ivarName:(NSString *)ivarName {
    NSMutableArray<MemoryObject *> *memoryObjectsFromCollection = [NSMutableArray new];
    NSArray *flattenCollection = [collection flattenCollection];
    [flattenCollection enumerateObjectsUsingBlock:^(id  _Nonnull element, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *elementClassName = [NSString stringWithUTF8String:object_getClassName(element)];
        MemoryObject *retainedCollectionElement = [[MemoryObject alloc] initWithClassName:elementClassName
                                                                            memoryAddress:(void *)element
                                                                                 ivarName:ivarName];
        [memoryObjectsFromCollection addObject:retainedCollectionElement];
    }];
    return [memoryObjectsFromCollection copy];
}

@end
