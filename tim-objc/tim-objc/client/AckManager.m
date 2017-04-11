//
//  AckManager.m
//  tim
//
//  Created by Main on 2017/3/20.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import "AckManager.h"
#import "TimEnum.h"

@implementation AckManager

- (void)processAck:(TimAckBean *)ab {
    NSString *ackType = [ab.ackType lowercaseString];
    NSString *ackStatus = ab.ackStatus;
    NSLog(@"ackType:%@",ab.ackType);
    NSLog(@"ackStatus:%@",ab.ackStatus);
    if ([@"login" isEqualToString:ackType]) {
        if ([@"400" isEqualToString:ackStatus]) {
            NSLog(@"用户名或密码错误");
            [self.client close];
        }
    }
    
//    switch (ab.ackType) {
//        case Login:
//            if ([@"400" isEqualToString:ackStatus]) {
//                NSLog(@"用户名或密码错误");
//                [self.client close];
//            }
//            break;
//        case Message:
//            break;
//        case Ping:
//            break;
//        case Presence:
//            break;
//        default:
//            break;
//    }
}

#pragma mark - Singleton

static AckManager *sharedSingleton = nil;

+ (id)allocWithZone:(struct _NSZone *)zone {
    if (sharedSingleton == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedSingleton = [super allocWithZone:zone];
        });
    }
    return sharedSingleton;
}

- (id)initWithClient:(id<ClientDelegate>)client {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [super init];
        sharedSingleton.client = client;
    });
    return sharedSingleton;
}

+ (instancetype)defaultManager:(id<ClientDelegate>)client {
    return [[self alloc] initWithClient:client];
}

+ (id)copyWithZone:(struct _NSZone *)zone {
    return sharedSingleton;
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone {
    return sharedSingleton;
}



@end
