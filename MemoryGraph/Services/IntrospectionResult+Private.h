//
//  IntrospectionResult+Private.h
//  MemoryGraph
//
//  Created by David Grigoryan on 24.10.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import "IntrospectionResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface IntrospectionResult ()

@property (copy, nonatomic) NSArray<MemoryObject *> *retainedObjects;
@property (copy, nonatomic) NSSet<NSString *> *visitedFields;

- (instancetype)initResult NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
