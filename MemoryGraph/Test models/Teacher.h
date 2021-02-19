//
//  Teacher.h
//  MemoryGraph
//
//  Created by David Grigoryan on 27.09.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Student;

NS_ASSUME_NONNULL_BEGIN

@interface Teacher : NSObject

@property (strong, nonatomic) Student *student;
@property (strong, nonatomic) id undefined;

@end

NS_ASSUME_NONNULL_END
