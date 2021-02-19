//
//  Graph.m
//  MemoryGraph
//
//  Created by David Grigoryan on 13.09.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import "Graph.h"
#import "NodeContainer.h"
#import "NodeProtocol.h"

@interface Graph ()

@property (strong, nonatomic) NSMutableDictionary<id<NSCopying>, NodeContainer *> *nodeMap;
@property (strong, nonatomic) NSMutableSet<id<NodeProtocol>> *visitedNodes;

@end


@implementation Graph

- (instancetype)init {
    self = [super init];
    if (self) {
        _nodeMap = [NSMutableDictionary new];
        _visitedNodes = [NSMutableSet new];
    }
    return self;
}


#pragma mark - Public

- (void)addEdgeFromNode:(id<NodeProtocol>)fromNode toNode:(id<NodeProtocol>)toNode {
    if (!self.nodeMap[fromNode]) {
        self.nodeMap[fromNode] = [NodeContainer new];
    }
    if (!self.nodeMap[toNode]) {
        self.nodeMap[toNode] = [NodeContainer new];
    }
    [self.nodeMap[fromNode] insertIntoChildrenList:toNode];
    [self.nodeMap[toNode] insertIntoParentsList:fromNode];
}

- (NSDictionary<id<NodeProtocol>, id> *)fullRawGraph {
    return [self rawGraphWithEmptyLeafs:YES];
}

- (NSDictionary<id<NodeProtocol>, id> *)rawGraphWithoutEmptyLeafs {
    return [self rawGraphWithEmptyLeafs:NO];
}

- (NSDictionary *)rootsMapForNode:(id<NodeProtocol>)node {
    NSDictionary<id<NodeProtocol>, id> *rootsMap = [self mapForNode:node];
    self.visitedNodes = [NSMutableSet new];
    return rootsMap;
}

- (NSString *)summary {
    NSUInteger nodeCount = [self nodeCount];
    NSUInteger edgeCount = [self edgeCount];
    return [NSString stringWithFormat:@"Node count: %ld, edge count: %ld", nodeCount, edgeCount];
}


#pragma mark - Private

- (NSUInteger)nodeCount {
    return [self.nodeMap allKeys].count;
}

- (NSUInteger)edgeCount {
    NSUInteger totalEdgeCount = 0;
    for (NodeContainer *nodeContainer in [self.nodeMap allValues]) {
        totalEdgeCount += nodeContainer.childrenList.count + nodeContainer.parentsList.count;
    }
    return totalEdgeCount;
}

- (NSDictionary<id<NodeProtocol>, id> *)rawGraphWithEmptyLeafs:(BOOL)emptyLeafs {
    NSMutableDictionary<id<NodeProtocol>, id> *rawGraph = [NSMutableDictionary new];
    for (id<NodeProtocol> key in [self.nodeMap allKeys]) {
        NSArray *childrenList = [self.nodeMap[key] childrenList];
        if (emptyLeafs) {
            rawGraph[key] = @"No leafs";
        }
        if (childrenList.count > 0) {
            rawGraph[key] = childrenList;
        }
    }
    NSLog(@"%@", [self summary]);
    return rawGraph;
}

- (NSDictionary<id<NodeProtocol>, id> *)mapForNode:(id<NodeProtocol>)node {
    if (!self.nodeMap[node]) {
        NSLog(@"Object not found");
        return @{};
    }
    
    NSArray<id<NodeProtocol>> *parentsList = [self.nodeMap[node] parentsList];
    
    if (parentsList.count == 0) {
        return @{node : @"No roots"};
    }
    
    NSMutableDictionary<id<NodeProtocol>, id> *nestedNodeMap = @{node : [NSMutableArray new]}.mutableCopy;
    
    for (id<NodeProtocol> rootNode in parentsList) {
        if ([self.visitedNodes containsObject:rootNode]) {
            continue;
        }
        [self.visitedNodes addObject:rootNode];
        [nestedNodeMap[node] addObject:[self mapForNode:rootNode]];
    }
    
    return nestedNodeMap;
}

@end
