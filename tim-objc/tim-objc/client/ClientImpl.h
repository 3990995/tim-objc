//
//  ClientImpl.h
//  tim
//
//  Created by Main on 2017/3/18.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientDelegate.h"
#import "AckDelegate.h"
#import "PresenceDelegate.h"
#import "ClientSub.h"
#import "Config.h"
#import "TimUtils.h"

@interface ClientImpl : NSObject<ClientDelegate>

@property (nonatomic, weak) id<AckDelegate> al;
@property (nonatomic, weak) id<MessageDelegate> ml;
@property (nonatomic, weak) id<PresenceDelegate> pl;

@property (nonatomic, strong,setter=setClientSub:) ClientSub *cs;
@property (nonatomic, assign) Flow fl;
@property (nonatomic, strong) Config *cf;

@property (nonatomic, assign) BOOL vd;
@property (atomic,assign) int pingNum;  // 保证多线程访问的原子性
@property (nonatomic, assign,getter=isProcessError) BOOL processError;

+ (ClientImpl *)newClient:(Config *)config;

- (void)disconnect;
@end
