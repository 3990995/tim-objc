//
//  TimManager.m
//  tim
//
//  Created by gossip2 on 17/4/5.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import "TimManager.h"
#import "TPClient.h"
#import "ClientImpl.h"
#import "ClientFactory.h"
#import "AckManager.h"
#import "MessageManager.h"

/// 登录监听心跳
@interface LoginHeartBeat : NSOperation {
    dispatch_semaphore_t _semaphore;
}
@property (atomic, assign) int ai;
@property (atomic, assign,getter=isConnected) BOOL connected;
@property (nonatomic, strong) Config *config;

- (instancetype)initWithConfig:(Config *)config;
@end

@implementation LoginHeartBeat

- (instancetype)initWithConfig:(Config *)config {
    self = [super init];
    if (self) {
        self.config = config;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _semaphore = dispatch_semaphore_create(1);
        });
    }
    return self;
}

- (void)main {
    while (!self.isConnected) {
        @try {
            [self relogin];
        } @catch (NSException *exception) {
            NSLog(@"exception:%@",exception.name);
        }
    }
}
- (void)relogin {
    @try {
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        int sleepTime = [self getAi];
        dispatch_semaphore_signal(_semaphore);
        if (sleepTime <= 5) {
            sleepTime = 1;
        } else if (sleepTime > 5 && sleepTime <= 30) {
            sleepTime = 60;
        } else if (sleepTime > 30 && sleepTime <= 100) {
            sleepTime = 180;
        } else if (sleepTime > 100) {
            sleepTime = 600;
        } else if (sleepTime > 500) {
            sleepTime = 1800;
        }
        [NSThread sleepForTimeInterval:sleepTime];
        [self login];
    } @catch (NSException *exception) {
        NSLog(@"exception:%@",exception.name);
    }
}

- (void)login {
    TPClient *tp = [TPClient newInstance:self.config];
    ClientImpl<ClientDelegate> *client = nil;
    @try {
        client = [tp getClient:[ClientFactory getClient:self.config]];
    } @catch (NSException *exception) {
        NSLog(@"连接IM服务器失败:%@",exception.name);
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        self.connected = NO;
        dispatch_semaphore_signal(_semaphore);
    }

    if (client) {
        [client addMessageDelegate:[MessageManager defaultManager]];
        [client addAckDelegate:[AckManager defaultManager:client]];
        @try {
            [client login:self.config.loginName pwd:self.config.password];
            dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
            self.connected = YES;
            dispatch_semaphore_signal(_semaphore);
        } @catch (NSException *exception) {
            NSLog(@"连接IM服务器失败:%@",exception.name);
            dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
            self.connected = NO;
            dispatch_semaphore_signal(_semaphore);
        }
    }
}


- (int)getAi {
    if (self.ai > 1000) {
        self.ai = 0;
    }
    return self.ai++;
}

@end



@interface TimManager ()
@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation TimManager

SingletonImplementation

- (void)loginWithConfig:(Config *)config {
    [self.queue addOperation:[[LoginHeartBeat alloc] initWithConfig:config]];
}

- (NSOperationQueue *)queue {
    if (_queue == nil) {
        _queue = [NSOperationQueue new];
        _queue.maxConcurrentOperationCount = 1;
    }
    return _queue;
}


@end



