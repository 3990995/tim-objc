//
//  ClientImpl.m
//  tim
//
//  Created by Main on 2017/3/18.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import "ClientImpl.h"

@interface ConnectHeartBeat : NSOperation {
    dispatch_semaphore_t _semaphore;
}
@property (nonatomic,strong) ClientImpl *ci;
@property (atomic, assign) int ai;//原子
- (instancetype)initWithClientImpl:(ClientImpl *)ci;
@end

@implementation ConnectHeartBeat
- (instancetype)initWithClientImpl:(ClientImpl *)ci {
    self = [super init];
    if (self) {
        self.ci = ci;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _semaphore = dispatch_semaphore_create(1);
        });
    }
    return self;
}

- (void)main {
    int sleepTime = self.ci.cf.heartBeat;
    while (self.ci.fl != Disconnect && self.ci.fl != AuthUnPass) {
        @try {
            for (int k = 0; k < sleepTime; k++) {
                [NSThread sleepForTimeInterval:1.0f];
                if (self.ci.isProcessError) {
                    @throw [NSException exceptionWithName:@"process error" reason:@"error" userInfo:nil];
                }
                NSLog(@"heartBeat:%d",k);
            }
            if (self.ci.pingNum >= 2) {
                @throw [NSException exceptionWithName:[NSString stringWithFormat:@"ping number over limit:%d",self.ci.pingNum] reason:nil userInfo:nil];
            }
            if (self.ci.fl == Auth) {
                [self.ci.cs.connect.c2sClient timPing:[TimUtils threadId]];
                [self.ci addPing];
                NSLog(@"ping timserver");
            }
        } @catch (NSException *exception) {
            NSLog(@"ping timserver error:%@",exception.name);
            [self.ci disconnect];
            [self.ci setValid:NO];
            [self.ci setProcessError:NO];
            [self sleep];
            @try {
                if (self.ci.fl == Auth) {
                    NSLog(@"tim try reconnect");
                    ClientSub *cs = [ClientSub newClient:self.ci config:self.ci.cf];
                    [self.ci setClientSub:cs];
                    [self.ci addAckDelegate:self.ci.al];
                    [self.ci addMessageDelegate:self.ci.ml];
                    [self.ci addPresenceDelegate:self.ci.pl];
                    [self.ci login:self.ci.config.loginName pwd:self.ci.cf.password];
                    [self.ci initPing];
                    [self initAi];
                }
            } @catch (NSException *exception) {
                NSLog(@"try reConnect error:%@",exception.name);
            }
        }
    }
}

- (void)sleep {
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
    } @catch (NSException *exception) {
        NSLog(@"exception:%@",exception.name);
    }
}

- (int)getAi {
    if (self.ai > 1000) {
        self.ai = 0;
    }
    return self.ai++;
}

- (void)initAi {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    self.ai = 0;
    dispatch_semaphore_signal(_semaphore);
}
@end



@interface ClientImpl (){
    dispatch_semaphore_t _semaphore;
}

@property (nonatomic, strong) NSOperationQueue *queue;
- (instancetype)initWithConfig:(Config *)config;
@end

@implementation ClientImpl

- (instancetype)initWithConfig:(Config *)config {
    self = [super init];
    if (self) {
        self.cf = config;
        @try {
            self.cs = [ClientSub newClient:self];
        } @catch (NSException *e) {
            ThrowTimException
        }

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _semaphore = dispatch_semaphore_create(1);
        });
    }
    return self;
}

static ClientImpl *ci = nil;

+ (ClientImpl *)newClient:(Config *)config {
    if (ci != nil) {
        [ci close];
    }
    ci = [[ClientImpl alloc] initWithConfig:config];
    ci.fl = Connect;
    return ci;
}

- (void)login:(NSString *)name pwd:(NSString *)pwd {
    [self.cs login:name pwd:pwd];
}

- (void)sendMessage:(NSString *)msg toName:(NSString *)toName tidType:(TidEnum)tidType {
    [self.cs sendMessage:msg toName:toName tidType:tidType];
}

- (void)close {
    self.fl = Disconnect;
    [self.cs close];
}

- (void)disconnect {
    [self.cs close];
}

- (void)addMessageDelegate:(id<MessageDelegate>)delegate {
    self.ml = delegate;
    [self.cs addMessageDelegate:delegate];
}

- (void)addPresenceDelegate:(id<PresenceDelegate>)delegate {
    self.pl = delegate;
    [self.cs addPresenceDelegate:delegate];
}

- (void)addAckDelegate:(id<AckDelegate>)delegate {
    self.al = delegate;
    [self.cs addAckDelegate:delegate];
}

- (BOOL)isConnect {
    return [self.cs isConnect];
}

- (BOOL)isLogin {
    return [self.cs isLogin];
}

- (void)setFlow:(Flow)flow {
    self.fl = flow;
    [self.cs setFlow:flow];
    if (flow == Auth) {
        if ([self.cf isReconnectionAllowed]) {
            ConnectHeartBeat *operation = [[ConnectHeartBeat alloc] initWithClientImpl:ci];
            [ci.queue addOperation:operation];
        }
    }
}

- (Config *)config {
    return self.cf;
}

- (void)setClientSub:(ClientSub *)cs {
    _cs = cs;
}

- (Flow)flow {
    return self.fl;
}

- (BOOL)isValid {
    if (!self.vd) {
        return self.vd;
    }
    @try {
        if (self.fl == Auth) {
            [self.cs.connect.c2sClient timPing:[TimUtils threadId]];
            [self addPing];
            NSLog(@"ping timserver valid");
        }
    } @catch (NSException *exception) {
        NSLog(@"valid error");
        return NO;
    }
    return self.vd;
}

- (void)loadMessageByNameList:(NSMutableArray<NSString *> *)toNameList fromStamp:(NSString *)fromStamp toStamp:(NSString *)toStamp limitCount:(int)limitCount {
    [self.cs loadMessageByNameList:toNameList fromStamp:fromStamp toStamp:toStamp limitCount:limitCount];
}

- (void)delMessageByName:(NSString *)toName mid:(NSString *)mid {
    [self.cs delMessageByName:toName mid:mid];
}

- (void)delAllMessageByName:(NSString *)toName {
    [self.cs delAllMessageByName:toName];
}

- (void)setValid:(BOOL)valid {
    _vd = valid;
}

- (void)addPing {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    self.pingNum ++;
    dispatch_semaphore_signal(_semaphore);
    NSLog(@"ping+1====>%d",self.pingNum);
}

- (void)initPing {
    NSLog(@"initping");
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    self.pingNum = 0;
    dispatch_semaphore_signal(_semaphore);
}

- (void)proessError:(BOOL)error {}

- (NSOperationQueue *)queue {
    if (_queue == nil) {
        _queue = [NSOperationQueue new];
        _queue.maxConcurrentOperationCount = 1;
    }
    return _queue;
}
@end
