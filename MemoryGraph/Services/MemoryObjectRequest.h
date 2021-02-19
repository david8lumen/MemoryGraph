//
//  MemoryObjectRequest.h
//  MemoryGraph
//
//  Created by David Grigoryan on 22.10.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MemoryReader;
@class MemoryObject;
typedef struct objc_ivar *Ivar;
typedef struct objc_property *objc_property_t;

NS_ASSUME_NONNULL_BEGIN

/// A class that requests a data fields from the memory object
@interface MemoryObjectRequest : NSObject

/// Creates an instance of memory object request
/// @param memoryReader An instance of the memoryReader
- (instancetype)initWithMemoryReader:(MemoryReader *)memoryReader;

/// Requests a memory objects from a given value and ivar
/// @param value instance which should be requested
/// @param ivar field data which should be taken from
/// @return A list of objects that are stored in a given value
- (NSArray<MemoryObject *> *)memoryObjectsFromValue:(const __unsafe_unretained id)value
                                               ivar:(Ivar)ivar;

/// Requests a memory objects from a given value and property
/// @param value instance which should be requested
/// @param property field data which should be taken from
/// @return A list of objects that are stored in a given value
- (NSArray<MemoryObject *> *)memoryObjectsFromValue:(const __unsafe_unretained id)value
                                     property:(objc_property_t)property;

@end

NS_ASSUME_NONNULL_END
