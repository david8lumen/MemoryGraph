//
//  MemoryObject.h
//  MemoryGraph
//
//  Created by David Grigoryan on 06.09.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NodeProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// A DTO class that represents a memory object model
@interface MemoryObject : NSObject <NodeProtocol>

@property (readonly, nonatomic) NSString *className;
@property (readonly, nonatomic) void *memoryAddress;
@property (readonly, nonatomic, nullable) NSString *ivarName;

/// Creates an object that represents a memory object model
/// @param className Object's class name
/// @param memoryAddress Object's memory address
/// @param ivarName Object's instance variable name which it belongs to
/// @return Initialized memory object model
- (instancetype)initWithClassName:(NSString *)className
                          memoryAddress:(void *)memoryAddress
                         ivarName:(nullable NSString *)ivarName;

/// Creates an object that represents a memory object model
/// @param object plain Cocoa object
/// @return Initialized memory object model
- (instancetype)initWithObject:(id)object;

@end

NS_ASSUME_NONNULL_END
