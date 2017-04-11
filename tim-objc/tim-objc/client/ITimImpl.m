//
//  ITimImpl.m
//  tim
//
//  Created by Main on 2017/3/18.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import "ITimImpl.h"

@implementation ITimImpl

- (instancetype)initWithConnect:(id<ConnectDelegate>)connect client:(id<ClientDelegate>)client {
    self = [super init];
    if (self) {
        self.connect = connect;
        self.client = client;
    }
    return self;
}

- (void)timStream:(TimParam *)param {}
- (void)timStarttls {}
- (void)timLogin:(Tid *)tid pwd:(NSString *)pwd {}
- (void)timAck:(TimAckBean *)ab {
    NSString *ackType = [ab ackType];
    NSString *ackStatus = [ab ackStatus];
    [self.client initPing];
    if (ackType != nil) {
        if ([@"login" isEqualToString:ackType]) {
            if ([@"200" isEqualToString:ackStatus]) {
                [self.client setFlow:Auth];
                [self.client setValid:YES];
            }
        }
        @try {
            [[self.connect ackDelegate] processAck:ab];
        } @catch (NSException *e) {
            @throw [TException exceptionWithName:e.name reason:e.reason];
        }
    }
}

- (void)timPresence:(TimPBean *)pbean {
    TimAckBean *ack = [TimAckBean new];
    [ack setAckType:@"presence"];
    [ack setAckStatus:@"200"];
    [ack setId:pbean.threadId];
    [[self.connect c2sClient] timAck:ack];
    @try {
        [[self.connect presenceDelegate] processPresence:pbean];
    } @catch (NSException *e) {
        @throw [TException exceptionWithName:e.name reason:e.reason];
    }
}

- (void)timMessage:(TimMBean *)mbean {
    TimAckBean *ack = [TimAckBean new];
    [ack setAckType:@"message"];
    [ack setAckStatus:@"200"];
    [ack setId:mbean.threadId];
    [[self.connect c2sClient] timAck:ack];
    @try {
        [[self.connect messageDelegate] processMessage:mbean];
    } @catch (NSException *e) {
        @throw [TException exceptionWithName:e.name reason:e.reason];
    }
}

- (void)timPing:(NSString *)threadId {
    if ([self.client flow] == Auth) {
        TimAckBean *ack = [TimAckBean new];
        [ack setAckType:@"ping"];
        [ack setId:threadId];
        [[self.connect c2sClient] timAck:ack];
    }
}

- (void)timError:(TimError *)e {}

- (void)timLogout {
    [self.client close];
}

- (void)timRegist:(Tid *)tid auth:(NSString *)auth {}
- (void)timMessageIq:(TimMessageIq *)timMsgIq iqType:(NSString *)iqType {}

- (void)timMessageResult:(TimMBean *)mbean {
    TimAckBean *ack = [TimAckBean new];
    [ack setAckType:@"message"];
    [ack setId:mbean.threadId];
    [[self.connect c2sClient] timAck:ack];
    [[self.connect messageDelegate] loadMessage:mbean];
}

- (void)timMessageList:(TimMBeanList *)mbeanList {
    TimAckBean *ack = [TimAckBean new];
    [ack setAckType:@"presence"];
    [ack setAckStatus:@"200"];
    [ack setId:mbeanList.threadId];
    [[self.connect c2sClient] timAck:ack];
    @try {
        [[self.connect messageDelegate] processMessages:[mbeanList timMBeanList]];
    } @catch (NSException *e) {
        @throw [TException exceptionWithName:e.name reason:e.reason];
    }
}

@end
