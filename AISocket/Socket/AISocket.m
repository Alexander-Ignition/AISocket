//
//  AISocket.m
//  AISocket
//
//  Created by Александр Игнатьев on 23.05.15.
//  Copyright (c) 2015 Alexander Ignition. All rights reserved.
//

#import "AISocket.h"
#import "AISocketThread.h"

@interface AISocket ()
@property (nonatomic, copy, readwrite) NSString *host;
@property (nonatomic, copy, readwrite) NSNumber *port;

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;
@end


@implementation AISocket

#pragma mark - init

+ (instancetype)socketWithHost:(NSString *)host port:(NSNumber *)port {
    return [[self alloc] initWithHost:host port:port];
}

- (instancetype)init {
    return [self initWithHost:nil port:nil];
}

- (instancetype)initWithHost:(NSString *)host port:(NSNumber *)port {
    if (self = [super init]) {
        self.host = (host != nil) ? host : @"localhost";
        self.port = (port != nil) ? port : @80;
    }
    return self;
}

#pragma mark - Connecting

- (void)connect
{
    if ([AISocketThread isSocketThread] == NO) {
        [self performSelectorOnSocketThread:@selector(connect)];
        return;
    }
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.host, self.port.unsignedIntValue, &readStream, &writeStream);
    
    self.inputStream = (__bridge NSInputStream *)readStream;
    self.outputStream = (__bridge NSOutputStream *)writeStream;
    
    self.inputStream.delegate = self;
    self.outputStream.delegate = self;
    
    [self.inputStream setProperty:(id)kCFBooleanTrue forKey:(NSString *)kCFStreamPropertyShouldCloseNativeSocket];
    [self.outputStream setProperty:(id)kCFBooleanTrue forKey:(NSString *)kCFStreamPropertyShouldCloseNativeSocket];
    
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self.inputStream open];
    [self.outputStream open];
}

- (void)disconnect
{
    if ([AISocketThread isSocketThread] == NO) {
        [self performSelectorOnSocketThread:@selector(disconnect)];
        return;
    }
    
    self.inputStream.delegate = self;
    self.outputStream.delegate = self;
    
    [self.inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self.inputStream close];
    [self.outputStream close];
    
    self.inputStream = nil;
    self.outputStream = nil;
}

- (void)reconnect
{
    [self disconnect];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self connect];
    });
}

#pragma mark - Send

- (void)sendData:(NSData *)data
{
    if ([AISocketThread isSocketThread] == NO) {
        [self performSelectorOnSocketThread:@selector(sendData:) withObject:data waitUntilDone:NO];
        return;
    }
    
    [self.outputStream write:[data bytes] maxLength:[data length]];
}

#pragma mark - NSStreamDelegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    //
}


@end
