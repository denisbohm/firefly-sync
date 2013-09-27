//
//  FDFireflyIceCollector.m
//  FireflyUtility
//
//  Created by Denis Bohm on 9/25/13.
//  Copyright (c) 2013 Firefly Design. All rights reserved.
//

#import <FireflyDevice/FDFireflyIceChannel.h>
#import <FireflyDevice/FDFireflyIceCoder.h>
#import "FDFireflyIceCollector.h"

@implementation FDFireflyIceCollectorEntry

@end

@interface FDFireflyIceCollector ()

@property NSSet *selectorNames;

@end

@implementation FDFireflyIceCollector

- (id)init
{
    if (self = [super init]) {
        _selectorNames = [NSSet setWithArray:@[
                                               @"fireflyIce:channel:version:",
                                               @"fireflyIce:channel:hardwareId:",
                                               @"fireflyIce:channel:debugLock:",
                                               @"fireflyIce:channel:time:",
                                               @"fireflyIce:channel:power:",
                                               @"fireflyIce:channel:site:",
                                               @"fireflyIce:channel:reset:",
                                               @"fireflyIce:channel:storage:",
                                               @"fireflyIce:channel:directTestModeReport:",
                                               @"fireflyIce:channel:sensing:",
                          ]];
        _dictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)complete
{
    [self done];
}

- (void)taskStarted
{
    [super taskStarted];
    
    [self.fireflyIce.coder sendGetProperties:self.channel properties:
     FD_CONTROL_PROPERTY_VERSION |
     FD_CONTROL_PROPERTY_HARDWARE_ID |
     FD_CONTROL_PROPERTY_DEBUG_LOCK |
     FD_CONTROL_PROPERTY_RTC |
     FD_CONTROL_PROPERTY_POWER |
     FD_CONTROL_PROPERTY_SITE |
     FD_CONTROL_PROPERTY_RESET |
     FD_CONTROL_PROPERTY_STORAGE];
    [self.fireflyIce.coder sendDirectTestModeReport:self.channel];
    
    [self next:@selector(complete)];
}

- (void)taskSuspended
{
    NSLog(@"task suspended");
}

- (void)taskResumed
{
    NSLog(@"task resumed");
}

- (void)taskCompleted
{
    NSLog(@"task completed");
}

- (id)objectForKey:(NSString *)key
{
    FDFireflyIceCollectorEntry *entry = _dictionary[key];
    return entry.object;
}

- (BOOL)respondsToSelector:(SEL)selector {
    NSString *selectorName = NSStringFromSelector(selector);
    return [_selectorNames containsObject:selectorName];
}

- (void)forwardInvocation:(NSInvocation *)invocation  {
    SEL selector = invocation.selector;
    NSString *selectorName = NSStringFromSelector(selector);
    NSArray *parts = [selectorName componentsSeparatedByString:@":"];
    NSString *key = parts[2];
    __unsafe_unretained id object;
    [invocation getArgument:&object atIndex:4];
    FDFireflyIceCollectorEntry *entry = [[FDFireflyIceCollectorEntry alloc] init];
    entry.date = [NSDate date];
    entry.object = object;
    _dictionary[key] = entry;
    
    [_delegate fireflyIceCollectorEntry:(FDFireflyIceCollectorEntry *)entry];
}

@end
