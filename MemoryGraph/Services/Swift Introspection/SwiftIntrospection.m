//
//  SwiftIntrospection.m
//  MemoryGraph
//
//  Created by David Grigoryan on 22.10.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import "SwiftIntrospection.h"
#import <objc/runtime.h>
#import "MemoryObject.h"
#import "IntrospectionResult+Private.h"
#import "MemoryObjectRequest.h"


@implementation SwiftIntrospection


#pragma mark - Inspectable

@synthesize memoryObjectRequest = _memoryObjectRequest;

- (IntrospectionResult *)introspectionResultFromObject:(MemoryObject *)memoryObject ivar:(Ivar)ivar {
    IntrospectionResult *result = [[IntrospectionResult alloc] initResult];
    Class inspectingClass = NSClassFromString(memoryObject.className);
    NSMutableArray *retainedObjects = [NSMutableArray new];
    NSMutableSet<NSString *> *visiteFields = [NSMutableSet new];
    
    unsigned int swiftPropertyCount = 0;
    NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
    objc_property_t *swiftProperties = class_copyPropertyList(inspectingClass, &swiftPropertyCount);
    
    if ([visiteFields containsObject:ivarName]) {
        return result;
    }
    
    [visiteFields addObject:ivarName];
    [retainedObjects addObjectsFromArray:[self.memoryObjectRequest memoryObjectsFromValue:(id)memoryObject.memoryAddress
                                                                 ivar:ivar]];
    
    for (int i = 0; i < swiftPropertyCount; i++) {
        objc_property_t swiftProperty = swiftProperties[i];
        NSString *swiftPropertyName = @(property_getName(swiftProperty));
        if ([result.visitedFields containsObject:swiftPropertyName]) {
            free(swiftProperties);
            return result;
        }
        [visiteFields addObject:swiftPropertyName];
        [retainedObjects addObjectsFromArray:[self.memoryObjectRequest memoryObjectsFromValue:(id)memoryObject.memoryAddress
                                                                    property:swiftProperty]];
    }
    free(swiftProperties);
    result.visitedFields = [visiteFields copy];
    result.retainedObjects = [retainedObjects copy];
    return result;
}

@end
