//
//  Teacher.m
//  MemoryGraph
//
//  Created by David Grigoryan on 27.09.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import "Teacher.h"
#import "Student.h"

@interface Teacher ()

@end

@implementation Teacher {
    Student *_secondStudent;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _secondStudent = [Student new];
    }
    return self;
}

@end
