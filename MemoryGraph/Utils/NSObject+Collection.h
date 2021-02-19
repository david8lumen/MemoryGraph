//
//  NSObject+Collection.h
//  MemoryGraph
//
//  Created by David Grigoryan on 26.09.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Collection)

/// Verifies that object is collection
- (BOOL)isCollection;

/// Extracting an inner collections into flatten structure
/// @discussion If the receiver has structure like [2, 3, [7,[8, 9]], 10, {"key" : "value"}] the result of this method will be [2,3,7,8,9,10, value]
- (NSArray *)flattenCollection;

@end

NS_ASSUME_NONNULL_END
