//
//  MemoryReader.m
//  MemoryGraph
//
//  Created by David Grigoryan on 06.09.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import "MemoryReader.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>
#import "MemoryValidator.h"
#import "MemoryObject.h"

typedef struct {
    Class isa;
} objc_structure_mock;

typedef struct {
    Class objectClass;
    void *objectMemory;
} memory_object_structure;

typedef void (^heap_object_enumeration_block_t)(memory_object_structure object_structure);

@interface MemoryReader ()

@property (assign, nonatomic) CFMutableSetRef registeredClasses;

@end


@implementation MemoryReader

- (void)dealloc {
    free(_registeredClasses);
}

#pragma mark - Public

- (NSArray<MemoryObject *> *)memoryObjects {
    return [self memoryObjectsWithExcludedClassNames:nil];
}

- (NSArray<MemoryObject *> *)memoryObjectsWithExcludedClassNames:(nullable NSArray<NSString *> *)classNames {
    self.registeredClasses = CFSetCreateMutable(NULL, 0, NULL);
    NSMutableArray<MemoryObject *> *memoryObjects = [NSMutableArray new];
    NSArray<Class> *excludedClasses = [self excludedClassesWithCustomClassNames:classNames];
    [self registerAvailableClassesWithoutExcludedClasses:excludedClasses];
    vm_address_t *zones = NULL;
    unsigned int zoneCount = 0;
    kern_return_t result = malloc_get_all_zones(TASK_NULL, reader, &zones, &zoneCount);
    if (result == KERN_SUCCESS) {
        for (unsigned int i = 0; i < zoneCount; i++) {
            malloc_zone_t *zone = (malloc_zone_t *)zones[i];
            malloc_introspection_t *introspection = zone->introspect;

            if (!introspection) {
                continue;
            }
            
            NSArray<MemoryObject *> *objectsFromZone = [self memoryObjectsFromZone:zone introspection:introspection];
            if (objectsFromZone) {
                [memoryObjects addObjectsFromArray:objectsFromZone];
            }
        }
    }
    return [memoryObjects copy];
}

- (BOOL)isPermittedCocoaObject:(const void *)object {
    return IsObjcObject(object) &&
    !IsObjcTaggedPointer(object, NULL) &&
    [self isPermittedCocoaClass:(class_from_ptr(object))];
}

- (BOOL)isPermittedCocoaClass:(Class)classToVerify {
    return CFSetContainsValue(self.registeredClasses, (__bridge const void *)(classToVerify));
}


#pragma mark - Private

- (NSArray<Class> *)excludedClassesWithCustomClassNames:(NSArray<NSString *> *)customClassNames {
    NSSet<NSString *> *defaultExcludedClassNames = [self defaultExcludedClassNames];
    NSSet<NSString *> *customExcludedClassNames = [NSSet setWithArray:customClassNames];
    NSSet<NSString *> *unitedExcludedClassNames = [defaultExcludedClassNames setByAddingObjectsFromSet:customExcludedClassNames];
    NSMutableArray<Class> *excludedClasses = [NSMutableArray new];
    for (NSString *className in unitedExcludedClassNames.allObjects) {
        Class excludedClass = NSClassFromString(className);
        if (excludedClass) {
            [excludedClasses addObject:excludedClass];
        } else {
            NSLog(@"There is not such class: <%@> to be excluded", className);
        }
    }
    return [excludedClasses copy];
}

- (NSSet<NSString *> *)defaultExcludedClassNames {
    return [NSSet setWithArray:@[
        @"_UIAlertControllerActionSheetCompactPresentationController",
        @"__NSXPCInterfaceProxy__UIKeyboardArbitration",
        @"__NSMallocBlock__",
        @"OS_dispatch_source",
        @"_NSThreadData",
        @"RBSAssertionIdentifier",
        @"RBSInheritance",
        @"NSThread",
        @"Graph",
        @"NodeContainer",
        @"MemoryObject",
        @"MemoryObjectIntrospection",
        @"MemoryReader",
        @"__NSCFString",
        @"UIScrollView"
    ]
            ];
}

- (void)registerAvailableClassesWithoutExcludedClasses:(NSArray<Class> *)excludedClasses {
    unsigned int classCount = 0;
    Class *classes = objc_copyClassList(&classCount);
    CFMutableSetRef classSet = CFSetCreateMutable(NULL, 0, NULL);
    for (unsigned int i = 0; i < classCount; i++) {
        Class inspectedClass = classes[i];
        CFSetAddValue(classSet, (__bridge const void *)(inspectedClass));
    }
    free(classes);
    
    for (Class cls in (__bridge NSSet *)classSet) {
        Class superclass = class_getSuperclass(cls);
        while (superclass != nil) {
            if (superclass == [NSObject class]) {
                if (![excludedClasses containsObject:cls]) {
                    CFSetAddValue(self.registeredClasses, (__bridge const void *)(cls));
                }
                break;
            } else {
                superclass = class_getSuperclass(superclass);
            }
        }
    }
    free(classSet);
}

- (NSArray<MemoryObject *> *)memoryObjectsFromZone:(malloc_zone_t *)zone
                                     introspection:(malloc_introspection_t *)introspection {
    
    NSMutableArray<MemoryObject *> *zoneObjects = [NSMutableArray new];
    heap_object_enumeration_block_t callback = ^(memory_object_structure memory_object) {
        introspection->force_unlock(zone);

        BOOL isPermittedCocoaObject = [self isPermittedCocoaObject:memory_object.objectMemory];
        if (isPermittedCocoaObject) {
            NSString *className = [NSString stringWithUTF8String:class_getName(memory_object.objectClass)];
            MemoryObject *memoryObject = [[MemoryObject alloc] initWithClassName:className
                                                                   memoryAddress:memory_object.objectMemory
                                                                        ivarName:nil];
            [zoneObjects addObject:memoryObject];
        }

        introspection->force_lock(zone);
    };

    if (introspection->enumerator) {
        introspection->force_lock(zone);
        introspection->enumerator(TASK_NULL,
                                  (void *)&callback,
                                  MALLOC_PTR_IN_USE_RANGE_TYPE,
                                  (vm_address_t)zone,
                                  reader,
                                  &recorder);
        introspection->force_unlock(zone);
    }
    
    return [zoneObjects copy];
}

static kern_return_t reader(__unused task_t remote_task,
                            vm_address_t remote_address,
                            __unused vm_size_t size,
                            void **local_memory) {
    *local_memory = (void *)remote_address;
    return KERN_SUCCESS;
}

static void recorder(task_t task,
                     void *context,
                     unsigned type,
                     vm_range_t *ranges,
                     unsigned rangeCount) {
    if (!context) {
        return;
    }

    for (unsigned int i = 0; i < rangeCount; i++) {
        vm_range_t range = ranges[i];
        objc_structure_mock *rawMemoryObject = (objc_structure_mock *)range.address;
        Class objectClass = NULL;
#ifdef __arm64__
        // http://www.sealiesoftware.com/blog/archive/2013/09/24/objc_explain_Non-pointer_isa.html
        extern uint64_t objc_debug_isa_class_mask WEAK_IMPORT_ATTRIBUTE;
        objectClass = (__bridge Class)((void *)((uint64_t)rawMemoryObject->isa & objc_debug_isa_class_mask));
#else
        objectClass = rawMemoryObject->isa;
#endif
        if (objectClass && rawMemoryObject) {
            memory_object_structure memoryStructure = { objectClass, rawMemoryObject };
            (*(heap_object_enumeration_block_t __unsafe_unretained *)context)(memoryStructure);
        }
    }
}

@end
