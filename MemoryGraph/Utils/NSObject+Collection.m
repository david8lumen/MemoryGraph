//
//  NSObject+Collection.m
//  MemoryGraph
//
//  Created by David Grigoryan on 26.09.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import "NSObject+Collection.h"

@implementation NSObject (Collection)

- (BOOL)isCollection {
    return [self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSSet class]];
}

- (NSArray *)flattenCollection {
    if ([self isKindOfClass:[NSArray class]]) {
        return [self flattenCollectionFromNestedCollection:(NSArray *)self];
    } else if ([self isKindOfClass:[NSDictionary class]]) {
        return [self flattenCollectionFromNestedCollection:[(NSDictionary *)self allValues]];
    } else if ([self isKindOfClass:[NSSet class]]) {
        return [self flattenCollectionFromNestedCollection:[(NSSet *)self allObjects]];
    }
    return @[];
}

- (NSArray *)flattenCollectionFromNestedCollection:(id)nestedCollection {
    NSMutableArray *flattenCollection = [NSMutableArray new];
    NSArray *objcCollection = (NSArray *)nestedCollection;
    for (id element in objcCollection) {
        if ([element isKindOfClass:[NSArray class]]) {
            [flattenCollection addObjectsFromArray:[self flattenCollectionFromNestedCollection:element]];
        } else if ([element isKindOfClass:[NSDictionary class]]) {
            [flattenCollection addObjectsFromArray:[self flattenCollectionFromNestedCollection:[element allValues]]];
        } else if ([element isKindOfClass:[NSSet class]]) {
            [flattenCollection addObjectsFromArray:[self flattenCollectionFromNestedCollection:[element allObjects]]];
        } else {
            [flattenCollection addObject:element];
        }
    }
    return [flattenCollection copy];
}

@end
