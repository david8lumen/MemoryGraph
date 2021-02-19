//
//  MemoryReader.h
//  MemoryGraph
//
//  Created by David Grigoryan on 06.09.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MemoryObject;
@class MemoryContainer;


NS_ASSUME_NONNULL_BEGIN

/// A class which allows to retrieve a memory info from the current process
@interface MemoryReader : NSObject

/// Memory objects that retrieved from the heap
/// @return A list of memory objects from the heap
- (NSArray<MemoryObject *> *)memoryObjects;

/// Memory objects that retrieved from the heap with excluded classes
/// @param classNames list of excluded class names
/// @return A list of memory objects without excluded classes
/// @discussion Providing a custom excluded class names guarantees that returning list of memory objects will not contain objects with specified classes
- (NSArray<MemoryObject *> *)memoryObjectsWithExcludedClassNames:(nullable NSArray<NSString *> *)classNames;

/// Verifies that given object is valid, can be read and belongs to registered Cocoa classes
/// @param object object which should be verified
/// @return YES if given object is valid and permitted
- (BOOL)isPermittedCocoaObject:(const void *)object;

/// Verifies that given class is permitted class and belongs to registered Cocoa classes
/// @param classToVerify class which should be verified
/// @return YES if given class is permitted
- (BOOL)isPermittedCocoaClass:(Class)classToVerify;

@end

NS_ASSUME_NONNULL_END
