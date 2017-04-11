//
//  ClientProxy.m
//  tim
//
//  Created by Main on 2017/3/21.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import "ClientProxy.h"

@interface ClientProxy ()

@property (nonatomic, weak) id<ClientDelegate> client;

@end

@implementation ClientProxy

+ (instancetype)newInstance:(Config *)config {
    return [[ClientProxy alloc] withConfig:config];
}

- (id)withObject:(id<ClientDelegate>)client {
    _client = client;
    return self;
}

- (id)withConfig:(Config *)config {
    _config = config;
    return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if (_client) {
        NSLog(@"proxy invocation obj method: %@",NSStringFromSelector([invocation selector]));
        [invocation setTarget:_client];
        [invocation invoke];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    if ([_client isKindOfClass:[NSObject class]]) {
        return [(NSObject *)_client methodSignatureForSelector:sel];
    }
    return [super methodSignatureForSelector:sel];
}

#pragma mark - ClientDelegate

- (void)login:(NSString *)name pwd:(NSString *)pwd {
    [_client login:name pwd:pwd];
}

- (void)sendMessage:(NSString *)msg toName:(NSString *)toName tidType:(TidEnum)tidType {
    NSLog(@"sendMessage:%@ toName:%@",msg,toName);
    [_client sendMessage:msg toName:toName tidType:tidType];
}

- (void)close {
    [_client close];
}

- (void)addMessageDelegate:(id<MessageDelegate>)delegate {
    [_client addMessageDelegate:delegate];
}

- (void)addPresenceDelegate:(id<PresenceDelegate>)delegate {
    [_client addPresenceDelegate:delegate];
}

- (void)addAckDelegate:(id<AckDelegate>)delegate {
    [_client addAckDelegate:delegate];
}

- (BOOL)isConnect {
    return [_client isConnect];
}

- (BOOL)isLogin {
    return [_client isLogin];
}

- (void)setFlow:(Flow)flow {
    [_client setFlow:flow];
}

- (Config *)config {
    return [_client config];
}

- (BOOL)isValid {
    return [_client isValid];
}

- (void)loadMessageByNameList:(NSMutableArray<NSString *> *)toNameList fromStamp:(NSString *)fromStamp toStamp:(NSString *)toStamp limitCount:(int)limitCount {
    [_client loadMessageByNameList:toNameList fromStamp:fromStamp toStamp:toStamp limitCount:limitCount];
}

- (void)delMessageByName:(NSString *)toName mid:(NSString *)mid {
    [_client delMessageByName:toName mid:mid];
}

- (void)delAllMessageByName:(NSString *)toName {
    [_client delAllMessageByName:toName];
}

- (void)setValid:(BOOL)valid {
    [_client setValid:valid];
}

- (void)addPing {
    [_client addPing];
}

- (void)initPing {
    [_client initPing];
}

- (void)proessError:(BOOL)error {
    [_client proessError:error];
}

@end
