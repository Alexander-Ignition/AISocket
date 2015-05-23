//
//  AISocketThread.m
//  AISocket
//
//  Created by Александр Игнатьев on 23.05.15.
//  Copyright (c) 2015 Alexander Ignition. All rights reserved.
//

#import "AISocketThread.h"
//#import "AISocket.h"

@implementation AISocketThread

+ (void)socketThreadMain {
    @autoreleasepool {
        [NSThread currentThread].name = @"AISocket";
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

+ (instancetype)socketThread {
    static AISocketThread *socketThread = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
//        socketThread = [[AISocketThread alloc] initWithTarget:self selector:@selector(socketThreadMain) object:nil];
        socketThread = [[AISocketThread alloc] init];
        [socketThread start];
    });
    
    return socketThread;
}

- (void)main {
    @autoreleasepool {
        
        [NSThread currentThread].name = @"AISocket";
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

+ (BOOL)isSocketThread {
    return [[NSThread currentThread] isEqual:[AISocketThread socketThread]];
}

@end

@implementation NSObject (AISocketThreadPerformAdditions)

- (void)performSelectorOnSocketThread:(SEL)aSelector {
    [self performSelectorOnSocketThread:aSelector withObject:nil waitUntilDone:NO];
}

- (void)performSelectorOnSocketThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait {
    [self performSelector:aSelector onThread:[AISocketThread socketThread] withObject:arg waitUntilDone:wait];
}

@end
