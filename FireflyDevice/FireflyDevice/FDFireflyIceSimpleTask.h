//
//  FDFireflyIceSimpleTask.h
//  FireflyDevice
//
//  Created by Denis Bohm on 10/17/13.
//  Copyright (c) 2013-2014 Firefly Design LLC / Denis Bohm. All rights reserved.
//

#import <FireflyDevice/FDFireflyIceTaskSteps.h>

@interface FDFireflyIceSimpleTask : FDFireflyIceTaskSteps

+ (FDFireflyIceSimpleTask *)simpleTask:(FDFireflyIce *)fireflyIce channel:(id<FDFireflyIceChannel>)channel comment:(NSString *)comment wait:(BOOL)wait block:(void (^)(void))block;

+ (FDFireflyIceSimpleTask *)simpleTask:(FDFireflyIce *)fireflyIce channel:(id<FDFireflyIceChannel>)channel block:(void (^)(void))block;

@property NSString *comment;
@property BOOL wait;
@property(strong) void (^block)(void);

@end
