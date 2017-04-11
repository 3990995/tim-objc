//
//  ConnectImpl.m
//  tim
//
//  Created by Main on 2017/3/16.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import "ConnectImpl.h"

@class ProcessOperation;
@protocol ProcessOperationDelegate <NSObject>
@required
/// 处理中的通知
- (void)processingNotifiy:(id<TProtocol>)protocol;
@end

#pragma mark - ProcessOperation

@interface ProcessOperation : NSOperation
@property (nonatomic, strong) ConnectImpl *connect;
@property (nonatomic, strong) ITimProcessor *processor;
@property (nonatomic, weak) id<TProtocol> protocol;
@property (nonatomic, weak) id<ProcessOperationDelegate> delegate;
@property (nonatomic, weak) id<ClientDelegate> timClient;

- (instancetype)initWithProtocal:(id<TProtocol>)protocal connect:(ConnectImpl *)connect delegate:(id<ProcessOperationDelegate>)delegate client:(id<ClientDelegate>)client;

@end

@implementation ProcessOperation

- (instancetype)initWithProtocal:(id<TProtocol>)protocal connect:(ConnectImpl *)connect delegate:(id<ProcessOperationDelegate>)delegate client:(id<ClientDelegate>)timClient {
    self = [super init];
    if (self) {
        self.protocol = protocal;
        self.connect = connect;
        self.timClient = timClient;
        self.processor = [[ITimProcessor alloc] initWithITim:[[ITimImpl alloc] initWithConnect:connect client:timClient]];
        self.delegate = delegate;
    }
    return self;
}

- (void)main {
    BOOL isProcess = NO;
    while (YES) {
        @try {
            if ([self.connect flow] != Stop) {
                if (!isProcess) {
                    isProcess = YES;
                    if (self.delegate && [self.delegate respondsToSelector:@selector(processingNotifiy:)]) {
                        [self.delegate processingNotifiy:self.protocol];
                    }
                }
                if ([self.connect flow] == Start) {
                    [self.connect setFlow:Run];
                }
                [self.processor processOnInputProtocol:self.protocol outputProtocol:self.protocol];
            }else{
                break;
            }
        } @catch (NSException *exception) {
            NSLog(@"ProcessOperation:%@",exception);
            [self.timClient proessError:YES];
            [self.connect close];
            break;
        } @finally {
        }
    }
    [self.timClient setValid:NO];
}
@end


#pragma mark -
#pragma mark - ConnectImpl

@interface ConnectImpl ()<ProcessOperationDelegate>
@property (nonatomic, strong) TNSStreamTransport *transport;
@property (nonatomic, strong) id<TProtocol> protocol;
@property (nonatomic, strong) ITimClient *ctimClient;
@property (nonatomic, strong) C2sClient *cc2sClient;
@property (nonatomic, strong) Config *config;
@property (nonatomic, assign) FlowConnect flowConnect;
@property (nonatomic, weak) id<MessageDelegate> cmessageDelegate;
@property (nonatomic, weak) id<PresenceDelegate> cpresenceDelegate;
@property (nonatomic, weak) id<AckDelegate> cackDelegate;
@property (nonatomic, weak) id<ClientDelegate> client;
@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation ConnectImpl

- (instancetype)initWithConfig:(Config *)config {
    self = [self init];
    if (self) {
        self.config = config;
        self.cc2sClient = [C2sClient newInstance:self];
    }
    return self;
}


+ (instancetype)newConnect:(id<ClientDelegate>)client {
    ConnectImpl *c = [[[self class] alloc] initWithConfig:[client config]];
    c.client = client;
    @try {
        [c connect];
    } @catch (NSException *e) {
        ThrowTimException
    }
    return c;
}

- (void)connect {
    @try {
        if ([self.config isTLS]) {
            ///TODO
            self.transport = [[TSSLSocketClient alloc] initWithHostname:self.config.ip port:self.config.port];
        }else{
            self.transport = [[TSocketClient alloc] initWithHostname:self.config.ip port:self.config.port];
        }
        self.protocol = [[TCompactProtocol alloc] initWithTransport:self.transport];
        self.flowConnect = Start;
        
        // 关于这部分多线程的与原理
        // www.cocoachina.com/ios/20150731/12819.html
        // www.cnblogs.com/wendingding/p/3811121.html
        // CountDownLatch cdl = new CountDownLatch(1);
        // new Thread(new TprocessorClient(protocol, this, cdl, client)).start();
        // cdl.await();
        ProcessOperation *operation = [[ProcessOperation alloc] initWithProtocal:self.protocol connect:self delegate:self client:self.client];
        [self.queue addOperation:operation];
    } @catch (NSException *e) {
        ThrowTimException
    }
}

- (void)close:(ConnectImpl *)connect {
    if (connect != nil) {
        @try {
            [connect setFlow:Stop];
            [connect close];
        } @catch (NSException *exception) {
            NSLog(@"close connect error:%@",exception);
        }
    }
}


#pragma mark - ProcessOperationDelegate
/// processer进入循环处理中后,回调这个方法初始化timClient
- (void)processingNotifiy:(id<TProtocol>)protocol {
    self.ctimClient = [[ITimClient alloc] initWithProtocol:protocol];
}

#pragma mark - 实现 ConnectDelegate 的其他方法

- (void)close {
    if (self.transport) {
        @try {
            self.flowConnect = Stop;
            _transport = nil; ///TODO 这里要关注一下是否可以close成功
        } @catch (NSException *exception) {
            NSLog(@"%@",exception.reason);
        }
    }
}

- (id<MessageDelegate>)messageDelegate {
    return self.cmessageDelegate;
}

- (id<PresenceDelegate>)presenceDelegate {
    return self.cpresenceDelegate;
}

- (id<AckDelegate>)ackDelegate {
    return self.cackDelegate;
}

- (C2sClient *)c2sClient {
    return self.cc2sClient;
}

- (ITimClient *)timClient {
    return self.ctimClient;
}

- (FlowConnect)flow {
    return self.flowConnect;
}

- (void)setFlow:(FlowConnect)flow {
    self.flowConnect = flow;
}

- (void)setMessageDelegate:(id<MessageDelegate>)delegate {
    self.cmessageDelegate = delegate;
}

- (void)setPresenceDelegate:(id<PresenceDelegate>)delegate {
    self.cpresenceDelegate = delegate;
}

- (void)setAckDelegate:(id<AckDelegate>)delegate {
    self.cackDelegate = delegate;
}


#pragma mark - getter 懒加载

- (NSOperationQueue *)queue {
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
    }
    return _queue;
}

@end






