//
//  MemoryObject.m
//  MemoryGraph
//
//  Created by David Grigoryan on 06.09.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import "MemoryObject.h"


@interface MemoryObject ()

@property (copy, nonatomic) NSString *className;
@property (assign, nonatomic) void *memoryAddress;
@property (copy, nonatomic) NSString *ivarName;

@end


@implementation MemoryObject

- (instancetype)initWithObject:(id)object {
    NSString *objectClassName = NSStringFromClass([object class]);
    return [self initWithClassName:objectClassName memoryAddress:(void *)object ivarName:nil];
}

- (instancetype)initWithClassName:(NSString *)className
                    memoryAddress:(void *)memoryAddress
                         ivarName:(nullable NSString *)ivarName {
    self = [super init];
    if (self) {
        _className = [className copy];
        _memoryAddress = memoryAddress;
        _ivarName = [ivarName copy];
    }
    return self;
}


#pragma mark - NSCopying

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    MemoryObject *copiedObject = [[[self class] allocWithZone:zone] init];
    copiedObject->_memoryAddress = self.memoryAddress;
    copiedObject->_className = self.className;
    copiedObject->_ivarName = self.ivarName;
    return copiedObject;
}


#pragma mark - NSObject

- (NSString *)description {
    NSString *ivarName = self.ivarName ? [NSString stringWithFormat:@" %@", self.ivarName] : @"";
    NSString *addressValue = [NSString stringWithFormat:@"%p", self.memoryAddress];
    return [NSString stringWithFormat:@"%@%@: %@", self.className, ivarName, addressValue];
}

- (BOOL)isEqual:(MemoryObject *)object
{
    if (![object isKindOfClass:[MemoryObject class]]) {
        return (id)object == self.memoryAddress;
    }
    return object.memoryAddress == self.memoryAddress;
}

- (NSUInteger)hash
{
    return (NSUInteger)self.memoryAddress;
}

@end
