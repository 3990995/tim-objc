//
//  IfaceImpl.m
//  tim
//
//  Created by Main on 2017/3/16.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import "IfaceImpl.h"

@implementation IfaceImpl

- (void)timStream:(TimParam *) param {}  // throws TException
- (void)timStarttls {}  // throws TException
- (void)timLogin:(Tid *) tid pwd: (NSString *) pwd {}  // throws TException
- (void)timAck:(TimAckBean *) ab{}  // throws TException
- (void)timPresence:(TimPBean *) pbean {}  // throws TException
- (void)timMessage:(TimMBean *) mbean {}  // throws TException
- (void)timPing:(NSString *) threadId {}  // throws TException
- (void)timError:(TimError *) e {}  // throws TException
- (void)timLogout{}  // throws TException
- (void)timRegist:(Tid *) tid auth: (NSString *) auth {}  // throws TException
- (void)timRoser:(TimRoster *) roster {}  // throws TException
- (void)timMessageList:(TimMBeanList *) mbeanList {}  // throws TException
- (void)timPresenceList:(TimPBeanList *) pbeanList {}  // throws TException
- (void)timMessageIq:(TimMessageIq *) timMsgIq iqType: (NSString *) iqType {}  // throws TException
- (void)timMessageResult:(TimMBean *) mbean {}  // throws TException
- (void)timProperty:(TimPropertyBean *) tpb {}  // throws TException
- (TimRemoteUserBean *)timRemoteUserAuth: (Tid *) tid pwd: (NSString *) pwd auth: (TimAuth *) auth { return nil; }  // throws TException
- (TimRemoteUserBean *)timRemoteUserGet: (Tid *) tid auth: (TimAuth *) auth { return nil; }  // throws TException
- (TimRemoteUserBean *)timRemoteUserEdit: (Tid *) tid ub: (TimUserBean *) ub auth: (TimAuth *) auth { return nil; }  // throws TException
- (TimResponseBean *)timResponsePresence: (TimPBean *) pbean auth: (TimAuth *) auth { return nil; }  // throws TException
- (TimResponseBean *)timResponseMessage: (TimMBean *) mbean auth: (TimAuth *) auth { return nil; }  // throws TException
- (TimMBeanList *)timResponseMessageIq: (TimMessageIq *) timMsgIq iqType: (NSString *) iqType auth: (TimAuth *) auth { return nil; }  // throws TException
- (TimResponseBean *)timResponsePresenceList: (TimPBeanList *) pbeanList auth: (TimAuth *) auth { return nil; }  // throws TException
- (TimResponseBean *)timResponseMessageList: (TimMBeanList *) mbeanList auth: (TimAuth *) auth { return nil; }  // throws TException

@end
