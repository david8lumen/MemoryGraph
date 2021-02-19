//
//  Person.h
//  MemoryGraph
//
//  Created by David Grigoryan on 02.10.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestingProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject <TestingProtocol> {
    @public
    id someStorableObj;
}

@end

NS_ASSUME_NONNULL_END
