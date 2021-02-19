//
//  MemoryObjectIntrospection.m
//  MemoryGraph
//
//  Created by David Grigoryan on 20.09.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import "MemoryObjectIntrospection.h"
#import "MemoryReader.h"
#import "MemoryObject.h"
#import <objc/runtime.h>
#import "IntrospectionResult.h"
#import "IntrospectionFactory.h"
#import "Inspectable.h"

@interface MemoryObjectIntrospection ()

@property (weak, nonatomic) MemoryReader *memoryReader;

@end


@implementation MemoryObjectIntrospection

- (instancetype)initWithMemoryReader:(MemoryReader *)memoryReader
{
    self = [super init];
    if (self) {
        _memoryReader = memoryReader;
    }
    return self;
}

- (NSArray<MemoryObject *> *)retainedObjectsFromObject:(MemoryObject *)memoryObject {
    NSMutableArray<MemoryObject *> *retainedObjects = [NSMutableArray new];
    NSMutableSet<NSString *> *visitedFields = [NSMutableSet new];
    Class inspectingClass = NSClassFromString(memoryObject.className);
    MemoryObjectRequest *request = [[MemoryObjectRequest alloc] initWithMemoryReader:self.memoryReader];
    
    while (inspectingClass != [NSObject class]) {
        
        unsigned int ivarCount = 0;
        Ivar *ivars = class_copyIvarList(inspectingClass, &ivarCount);
        
        for (unsigned int ivarIndex = 0; ivarIndex < ivarCount; ivarIndex++) {
            Ivar ivar = ivars[ivarIndex];
            NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
            
            // avoid private ivars
            if ([ivarName hasPrefix:@"__"]) {
                continue;
            }
            
            const char *ut8TypeEncoding = ivar_getTypeEncoding(ivar);
            NSString *typeEncoding = ut8TypeEncoding == NULL ? @"" : @(ut8TypeEncoding);
            IntrospectionFactory *introspectionFactory = [IntrospectionFactory new];
            id<Inspectable> introspection = [introspectionFactory inspectableInstanceFromTypeEncoding:typeEncoding
                                                                                      inspectingClass:inspectingClass];
            introspection.memoryObjectRequest = request;
            if ([visitedFields containsObject:ivarName]) {
                continue;
            }
            IntrospectionResult *result = [introspection introspectionResultFromObject:memoryObject
                                                                                  ivar:ivar];
            [retainedObjects addObjectsFromArray:result.retainedObjects];
            [visitedFields setByAddingObjectsFromSet:result.visitedFields];
        }
        free(ivars);
        Class parentClass = class_getSuperclass(inspectingClass);
        if (![self.memoryReader isPermittedCocoaClass:parentClass]) {
            break;
        }
        inspectingClass = parentClass;
    }
    
    return retainedObjects;
}

@end
