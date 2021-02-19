//
//  IntrospectionResult.m
//  MemoryGraph
//
//  Created by David Grigoryan on 22.10.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import "IntrospectionResult+Private.h"

@implementation IntrospectionResult

- (instancetype)initResult
{
    self = [super init];
    if (self) {
        _retainedObjects = @[];
        _visitedFields = [NSSet set];
    }
    return self;
}

@end
