//
//  ObjcIntrospection.m
//  MemoryGraph
//
//  Created by David Grigoryan on 22.10.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import "ObjcIntrospection.h"
#import "MemoryObjectRequest.h"
#import "IntrospectionResult+Private.h"
#import "MemoryObject.h"
#import <objc/runtime.h>


@implementation ObjcIntrospection


#pragma mark - Inspectable

@synthesize memoryObjectRequest = _memoryObjectRequest;

- (IntrospectionResult *)introspectionResultFromObject:(MemoryObject *)memoryObject ivar:(Ivar)ivar {
    IntrospectionResult *result = [[IntrospectionResult alloc] initResult];
    Class inspectingClass = NSClassFromString(memoryObject.className);
    NSMutableArray *retainedObjects = [NSMutableArray new];
    NSMutableSet<NSString *> *visitedFields = [NSMutableSet new];
    unsigned int propertyCount = 0;
    NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
    objc_property_t *properties = class_copyPropertyList(inspectingClass, &propertyCount);

    if ([result.visitedFields containsObject:ivarName]) {
        return result;
    }
    
    if (propertyCount == 0) {
        [retainedObjects addObjectsFromArray:[self.memoryObjectRequest memoryObjectsFromValue:(id)memoryObject.memoryAddress ivar:ivar]];
    } else {
        for (int i = 0; i < propertyCount; i++) {
            objc_property_t property = properties[i];
            if ([self ivar:ivar belongsToProperty:property] &&
                [self isAllowedProperty:property]) {
                [retainedObjects addObjectsFromArray:[self.memoryObjectRequest memoryObjectsFromValue:(id)memoryObject.memoryAddress ivar:ivar]];
            }
        }
    }
    [visitedFields addObject:ivarName];
    
    free(properties);
    result.visitedFields = [visitedFields copy];
    result.retainedObjects = [retainedObjects copy];
    return result;
}


#pragma mark - Private

- (BOOL)isAllowedProperty:(objc_property_t)property {
    return ![self isWeakProperty:property] && ![self isDynamicProperty:property];
}

- (BOOL)isWeakProperty:(objc_property_t)property {
    NSString *propertyAttributes = [self attributesFromProperty:property];
    return [propertyAttributes containsString:@",w"] || [propertyAttributes containsString:@"w,"];
}

- (BOOL)isDynamicProperty:(objc_property_t)property {
    NSString *propertyAttributes = [self attributesFromProperty:property];
    return [propertyAttributes containsString:@",d"] || [propertyAttributes containsString:@"d,"];
}

- (BOOL)ivar:(Ivar)ivar belongsToProperty:(objc_property_t)property {
    NSString *typeEncoding = [self ivarEncodingFromIvar:ivar];
    NSString *propertyAttributes = [self attributesFromProperty:property];
    NSString *plainTypeEncoding = [[typeEncoding componentsSeparatedByString:@"@"] componentsJoinedByString:@""];
    NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
    return [propertyAttributes containsString:plainTypeEncoding.lowercaseString] || [propertyAttributes containsString:ivarName.lowercaseString];
}

- (NSString *)attributesFromProperty:(objc_property_t)property {
    return [NSString stringWithUTF8String:property_getAttributes(property)].lowercaseString;
}

- (NSString *)ivarEncodingFromIvar:(Ivar)ivar {
    const char *ut8TypeEncoding = ivar_getTypeEncoding(ivar);
    NSString *typeEncoding = ut8TypeEncoding == NULL ? @"" : @(ut8TypeEncoding);
    return typeEncoding;
}

@end
