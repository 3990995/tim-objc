//
//  C2sClient.m
//  tim
//
//  Created by Main on 2017/3/16.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import "C2sClient.h"

#define ThrowTException @throw [TException exceptionWithName:[NSString stringWithFormat:@"Flow is not run:%lu",(unsigned long)[self.connect flow]]];

@interface C2sClient ()

@property (nonatomic,weak) id<ConnectDelegate> connect;

@end

@implementation C2sClient

+ (instancetype)newInstance:(id<ConnectDelegate>)connect {
    C2sClient *c2s = [C2sClient new];
    c2s.connect = connect;
    return c2s;
}

- (void)timStream:(TimParam *)param {
    if ([self.connect flow] == Run) {
        [[self.connect timClient] timStream:param];
    } else {
       ThrowTException
    }
}

- (void)timStarttls {
    if ([self.connect flow] == Run) {
        [[self.connect timClient] timStarttls];
    } else {
        ThrowTException
    }
}

- (void)timLogin:(Tid *)tid pwd:(NSString *)pwd {
    if ([self.connect flow] == Run) {
        [[self.connect timClient] timLogin:tid pwd:pwd];
    } else {
        ThrowTException
    }
}

- (void)timAck:(TimAckBean *)ab {
    if ([self.connect flow] == Run) {
        [[self.connect timClient] timAck:ab];
    } else {
        ThrowTException
    }
}

- (void)timPresence:(TimPBean *)pbean {
    if ([self.connect flow] == Run) {
        [[self.connect timClient] timPresence:pbean];
    } else {
        ThrowTException
    }
}

- (void)timMessage:(TimMBean *)mbean {
    if ([self.connect flow] == Run) {
        [[self.connect timClient] timMessage:mbean];
    } else {
        ThrowTException
    }
}

- (void)timPing:(NSString *)threadId {
    if ([self.connect flow] == Run) {
        [[self.connect timClient] timPing:threadId];
    } else {
        ThrowTException
    }
}

- (void)timError:(TimError *)e {
    if ([self.connect flow] == Run) {
        [[self.connect timClient] timError:e];
    } else {
        ThrowTException
    }
}

- (void)timLogout {
    if ([self.connect flow] == Run) {
        [[self.connect timClient] timLogout];
    } else {
        ThrowTException
    }
}

- (void)timMessageIq:(TimMessageIq *)timMsgIq iqType:(NSString *)iqType {
    if ([self.connect flow] == Run) {
        [[self.connect timClient] timMessageIq:timMsgIq iqType:iqType];
    } else {
        ThrowTException
    }
}

- (void)timMessageResult:(TimMBean *)mbean { }

@end
