//
//  ClientSub.m
//  tim
//
//  Created by Main on 2017/3/16.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import "ClientSub.h"
#import "ConnectImpl.h"
#import "TimUtils.h"

@implementation ClientSub

- (instancetype)initWithConfig:(Config *)config {
    self = [super init];
    if (self) {
        self.cconfig = config;
    }
    return self;
}

+ (instancetype)newClient:(id<ClientDelegate>)client {
    ClientSub *ci = [[ClientSub alloc] initWithConfig:[client config]];
    NSLog(@"tim ip:%@", [client config].ip);
    NSLog(@"tim port: %d",[client config].port);
    @try {
        ci.connect = [ConnectImpl newConnect:client];
        ci.cflow = Connect;
    } @catch (NSException *e) {
        NSLog(@"newClient error:%@",e.reason);
        ThrowTimException
    }
    return ci;
}

+ (instancetype)newClient:(id<ClientDelegate>)client config:(Config *)config {
    ClientSub *ci = [[ClientSub alloc] initWithConfig:config];
    NSLog(@"tim ip:%@", config.ip);
    NSLog(@"tim port: %d", config.port);
    @try {
        ci.connect = [ConnectImpl newConnect:client];
        ci.cflow = Connect;
    } @catch (NSException *e) {
        NSLog(@"newClient error:%@",e.reason);
        ThrowTimException
    }
    return ci;
}

- (void)login:(NSString *)name pwd:(NSString *)pwd {
    @try {
        TimParam *param = [TimParam new];
        [param setVersion:(int16_t)timConstants.protocolversion];
        [param setInterflow:@"1"];
        [self.connect.c2sClient timStream:param];
        [self.cconfig setLoginName:name];
        [self.cconfig setPassword:pwd];
        [self.connect.c2sClient timLogin:[TimUtils newTid:name config:self.cconfig tidType:Normal] pwd:pwd];
    } @catch (NSException *e) {
        ThrowTimException
    }
}

- (void)sendMessage:(NSString *)msg toName:(NSString *)toName tidType:(TidEnum)tidType {
    @try {
        [self.connect.c2sClient timMessage:[TimUtils newTimMBean:toName msg:msg tidType:tidType config:self.cconfig]];
    } @catch (NSException *e) {
        ThrowTimException
    }
}

- (void)close {
    [self.connect close];
}

- (void)addMessageDelegate:(id<MessageDelegate>)delegate {
    [self.connect setMessageDelegate:delegate];
}

- (void)addPresenceDelegate:(id<PresenceDelegate>)delegate {
    [self.connect setPresenceDelegate:delegate];
}

- (void)addAckDelegate:(id<AckDelegate>)delegate {
    [self.connect setAckDelegate:delegate];
}

- (BOOL)isConnect {
    return self.cflow == Connect;
}

- (BOOL)isLogin {
    return self.cflow == Auth;
}

- (void)setFlow:(Flow)flow {
    self.cflow = flow;
}

- (Config *)config {
    return self.cconfig;
}

- (Flow)flow {
    return self.cflow;
}

- (BOOL)isValid {
    return NO;
}

- (void)loadMessageByNameList:(NSMutableArray<NSString *> *)toNameList fromStamp:(NSString *)fromStamp toStamp:(NSString *)toStamp limitCount:(int)limitCount {
    @try {
        TimMessageIq *timMsgIq = [TimMessageIq new];
        timMsgIq.timPage = [TimPage new];
        [timMsgIq setTidlist:toNameList];
        [timMsgIq.timPage setFromTimeStamp:fromStamp];
        [timMsgIq.timPage setToTimeStamp:toStamp];
        [timMsgIq.timPage setLimitCount:limitCount];
        [self.connect.c2sClient timMessageIq:timMsgIq iqType:@"get"];
    } @catch (NSException *e) {
        ThrowTimException
    }
}

- (void)delMessageByName:(NSString *)toName mid:(NSString *)mid {
    @try {
        TimMessageIq *timMsgIq = [TimMessageIq new];
        NSMutableArray<NSString *> *namelist = [NSMutableArray new];
        [namelist addObject:toName];
        [timMsgIq setTidlist:namelist];
        NSMutableArray<NSString *> *midlist = [NSMutableArray new];
        [midlist addObject:mid];
        [timMsgIq setMidlist:midlist];
        [self.connect.c2sClient timMessageIq:timMsgIq iqType:@"del"];
    } @catch (NSException *e) {
        ThrowTimException
    }
}

- (void)delAllMessageByName:(NSString *)toName {
    @try {
        TimMessageIq *timMsgIq = [TimMessageIq new];
        NSMutableArray<NSString *> *namelist = [NSMutableArray new];
        [namelist addObject:toName];
        [timMsgIq setTidlist:namelist];
        [self.connect.c2sClient timMessageIq:timMsgIq iqType:@"delAll"];
    } @catch (NSException *e) {
        ThrowTimException
    }
}

- (void)setValid:(BOOL)valid {}

- (void)addPing {
    NSLog(@"clientsub addping");
}

- (void)initPing {
    NSLog(@"clientsub initping");
}

- (void)proessError:(BOOL)error {
    NSLog(@"processError:%@",(error ? @"yes":@"no"));
}

@end
