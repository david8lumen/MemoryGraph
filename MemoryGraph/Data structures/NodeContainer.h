//
//  NodeContainer.h
//  MemoryGraph
//
//  Created by David Grigoryan on 19.09.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol NodeProtocol;

NS_ASSUME_NONNULL_BEGIN

/// A class that represents a "parent-children" relations. Each object of this class contains a list of parents and children nodes
@interface NodeContainer : NSObject

/// Insert node into children list
/// @param child Child node which should be inserted into children list
- (void)insertIntoChildrenList:(id<NodeProtocol>)child;

/// Insert node into parents list
/// @param parent Parent node which should be inserted into parents list
- (void)insertIntoParentsList:(id<NodeProtocol>)parent;

/// Returns a list of children objects of the node
/// @return A list of children objects
- (NSArray<id<NodeProtocol>> *)childrenList;

/// Returns a list of parents objects of the node
/// @return A list of parents objects
- (NSArray<id<NodeProtocol>> *)parentsList;

@end

NS_ASSUME_NONNULL_END
