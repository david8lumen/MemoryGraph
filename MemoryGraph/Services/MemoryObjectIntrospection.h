//
//  MemoryObjectIntrospection.h
//  MemoryGraph
//
//  Created by David Grigoryan on 20.09.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MemoryObject;
@class MemoryReader;

NS_ASSUME_NONNULL_BEGIN

/// A class that allows to retrieve the additional data from Cocoa objects
@interface MemoryObjectIntrospection : NSObject

/// Creates a reader of Cocoa objects
/// @param memoryReader instance of memory reader
/// @return Instance of Cocoa objects reader
- (instancetype)initWithMemoryReader:(MemoryReader *)memoryReader;

/// Returns a list of memory objects which are retained by the given object
/// @param memoryObject An instance of memory object which should be inspected
/// @return A list of memory objects which are retained by the given memory object
- (NSArray<MemoryObject *> *)retainedObjectsFromObject:(MemoryObject *)memoryObject;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE; 

@end

NS_ASSUME_NONNULL_END
