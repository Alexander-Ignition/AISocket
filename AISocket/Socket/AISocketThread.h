//
//  AISocketThread.h
//  AISocket
//
//  Created by Александр Игнатьев on 23.05.15.
//  Copyright (c) 2015 Alexander Ignition. All rights reserved.
//

@import Foundation;

@class AISocket;

@interface AISocketThread : NSThread

+ (instancetype)socketThread;
+ (BOOL)isSocketThread;

@end

@interface NSObject (AISocketThreadPerformAdditions)

- (void)performSelectorOnSocketThread:(SEL)aSelector;
- (void)performSelectorOnSocketThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait;

@end
