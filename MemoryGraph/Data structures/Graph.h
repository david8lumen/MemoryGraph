//
//  Graph.h
//  MemoryGraph
//
//  Created by David Grigoryan on 13.09.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol NodeProtocol;

NS_ASSUME_NONNULL_BEGIN

/// A class that represents a graph structure
@interface Graph : NSObject

/// Method which adds the edge between provided nodes
/// @param fromNode The source node
/// @param toNode The destination node
/// @discussion Nodes should support hashable protocol in order to be uniquely identified in a graph
- (void)addEdgeFromNode:(id<NodeProtocol>)fromNode toNode:(id<NodeProtocol>)toNode;

/// Returns a full map of graph's relations
/// @return A map of graph's relations
- (NSDictionary *)fullRawGraph;

/// Returns a map of root nodes by given node
/// @param node Node which roots map should be constructed
/// @return A map of roots by given node
- (NSDictionary *)rootsMapForNode:(id<NodeProtocol>)node;

/// Returns a map of graph's relations without empty leafs
/// @return A map of graph's relations without empty leafs
/// @discussion In graph, which presented below, only A, B, F and C nodes will be encounter
/// {A} ----- {B} ---- {null}
///  | \
///  |   {F} ----- {null}
///  |
/// {C} ---- {null}
- (NSDictionary *)rawGraphWithoutEmptyLeafs;

@end

NS_ASSUME_NONNULL_END
