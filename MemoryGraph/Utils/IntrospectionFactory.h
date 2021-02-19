//
//  IntrospectionFactory.h
//  MemoryGraph
//
//  Created by David Grigoryan on 22.10.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemoryObjectRequest.h"
@protocol Inspectable;
@class MemoryObjectRequest;

NS_ASSUME_NONNULL_BEGIN

/// A factory that creates a concrete instance which adopts to inspectable protocol
@interface IntrospectionFactory : NSObject

/// Creates a concrete instance which adopts to to inspectable protocol by provided type encoding and class
/// @param typeEncoding A ivar's type encoding
/// @param inspectingClass An inspected class
- (id<Inspectable>)inspectableInstanceFromTypeEncoding:(NSString *)typeEncoding
                                       inspectingClass:(Class)inspectingClass;

@end

NS_ASSUME_NONNULL_END
