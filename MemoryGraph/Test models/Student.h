//
//  Student.h
//  MemoryGraph
//
//  Created by David Grigoryan on 27.09.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
@class Teacher;

NS_ASSUME_NONNULL_BEGIN

@interface Student : Person

@property (strong, nonatomic) Teacher *teacher;

@end

NS_ASSUME_NONNULL_END
