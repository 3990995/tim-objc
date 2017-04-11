//
//  ConnectDelegate.h
//  tim
//
//  Created by Main on 2017/3/16.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TIMService.h"
#import "MessageDelegate.h"
#import "PresenceDelegate.h"
#import "AckDelegate.h"
#import "TimEnum.h"

@class C2sClient;

@protocol ConnectDelegate <NSObject>

- (id<MessageDelegate>)messageDelegate;

- (void)setMessageDelegate:(id<MessageDelegate>)delegate;

- (id<PresenceDelegate>)presenceDelegate;

- (void)setPresenceDelegate:(id<PresenceDelegate>)delegate;

- (id<AckDelegate>)ackDelegate;

- (void)setAckDelegate:(id<AckDelegate>)delegate;

- (C2sClient *)c2sClient;

- (ITimClient *)timClient;

- (FlowConnect)flow;

- (void)setFlow:(FlowConnect)flow;

- (void)close;

@end
