//
//  AISocket.h
//  AISocket
//
//  Created by Александр Игнатьев on 23.05.15.
//  Copyright (c) 2015 Alexander Ignition. All rights reserved.
//

@import Foundation;

@interface AISocket : NSObject <NSStreamDelegate>

@property (nonatomic, copy, readonly) NSString *host;
@property (nonatomic, copy, readonly) NSNumber *port;

+ (instancetype)socketWithHost:(NSString *)host port:(NSNumber *)port;
- (instancetype)initWithHost:(NSString *)host port:(NSNumber *)port;

- (void)connect;
- (void)disconnect;
- (void)reconnect;

- (void)sendData:(NSData *)data;

@end
