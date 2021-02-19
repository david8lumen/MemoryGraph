//
//  MemoryValidator.h
//  MemoryGraph
//
//  Created by David Grigoryan on 06.09.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//


#include <stdbool.h>
#include <objc/objc.h>

/**
 Test if a pointer is an Objective-C object

 @param inPtr is the pointer to check
 @return true if the pointer is an Objective-C object
 */
bool IsObjcObject(const void *inPtr);
Class class_from_ptr(const void *inPtr);

/**
 Test if a pointer is a tagged pointer

 @param inPtr is the pointer to check
 @param outClass returns the registered class for the tagged pointer.
 @return true if the pointer is a tagged pointer.
 */
bool IsObjcTaggedPointer(const void *inPtr, Class *outClass);

