//
//  ObjcIntrospection.h
//  MemoryGraph
//
//  Created by David Grigoryan on 22.10.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Inspectable.h"
@class MemoryObjectRequest;

NS_ASSUME_NONNULL_BEGIN

/// A concrete class which adopts to inspectable protocol for inspecting Objective-C objects
@interface ObjcIntrospection : NSObject <Inspectable>

@end

NS_ASSUME_NONNULL_END
