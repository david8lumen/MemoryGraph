//
//  MemoryService.h
//  MemoryGraph
//
//  Created by David Grigoryan on 13.09.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol NodeProtocol;

NS_ASSUME_NONNULL_BEGIN

/// Service that allows to work with memory data
@interface MemoryService : NSObject

/// Returns the application's memory graph in raw representation
/// @return Application's memory graph
- (NSDictionary<id<NodeProtocol>, id> *)fullMemoryGraph;

/// Returns the application's memory graph without provided class names in raw representation
/// @param classNames A list of excluded class names
/// @return Application's memory graph without objects with provided class names
- (NSDictionary<id<NodeProtocol>, id> *)memoryGraphWithoutClassNames:(NSArray<NSString *> *)classNames;

/// Returns the object's retainers graph
/// @param object An object which retainers graph should be constructed from
/// @return Object's retainers graph
- (NSDictionary<id<NodeProtocol>, id> *)retainersForObject:(id)object;

/// Returns the application's memory graph in raw representation without empty nodes
/// @return Application's memory graph without empty nodes
- (NSDictionary<id<NodeProtocol>, id> *)memoryGraphWithChildrenOnly;

@end

NS_ASSUME_NONNULL_END
