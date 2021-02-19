//
//  AppDelegate.m
//  MemoryGraph
//
//  Created by David Grigoryan on 06.09.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

#import "AppDelegate.h"
#import "MemoryService.h"
#import "Student.h"
#import "Teacher.h"
#import "MemoryGraph-Swift.h"

#define NSNLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@interface AppDelegate ()

@property (copy, nonatomic) NSArray *testModels;
@property (strong, nonatomic) Teacher *teacher;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self prepareTestModels];
    MemoryService *memoryService = [MemoryService new];
    NSDictionary *graph = [memoryService fullMemoryGraph];
    NSNLog(@"%@", graph);
    return YES;
}

- (void)prepareTestModels {
    self.teacher = [Teacher new];
    Dog *dog = [Dog new];
    SwiftContainer *container = [SwiftContainer new];
    Student *student = [Student new];
    student->someStorableObj = self.teacher;
    student.protocolProperty = dog;
    self.teacher.student = student;
    self.teacher.undefined = student;
    student.teacher = self.teacher;
    self.testModels = @[self.teacher, student, dog, container];
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
