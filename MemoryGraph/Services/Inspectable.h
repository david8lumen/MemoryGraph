//
//  Inspectable.h
//  MemoryGraph
//
//  Created by David Grigoryan on 22.10.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MemoryObject;
@class IntrospectionResult;
@class MemoryObjectRequest;
typedef struct objc_ivar *Ivar;


NS_ASSUME_NONNULL_BEGIN

/// A protocol which defines introspection behavior
@protocol Inspectable <NSObject>

///
@property (strong, nonatomic) MemoryObjectRequest *memoryObjectRequest;

/// Creates and returns an instance of introspection result from a given memory object and ivar
/// @param memoryObject object that should be read
/// @param ivar value that should be taken from
- (IntrospectionResult *)introspectionResultFromObject:(MemoryObject *)memoryObject ivar:(Ivar)ivar;

@end

NS_ASSUME_NONNULL_END
