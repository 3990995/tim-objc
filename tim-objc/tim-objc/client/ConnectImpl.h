//
//  ConnectImpl.h
//  tim TIM连接实现
//
//  Created by Main on 2017/3/16.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectDelegate.h"
#import "TTransport.h"
#import "TSocketClient.h"
#import "TSSLSocketClient.h"
#import "TCompactProtocol.h"
#import "C2sClient.h"
#import "Config.h"
#import "ClientDelegate.h"
#import "ITimImpl.h"
#import "TimException.h"

#define ThrowTimException @throw [TimException exceptionWithName:e.name reason:e.reason userInfo:e.userInfo];

@interface ConnectImpl : NSObject<ConnectDelegate>

/**
 * @brief 新建连接
 *
 * @param client client实例
 * @exception TimException
 *
 * @return 连接im服务器的实例
 */
+ (instancetype)newConnect:(id<ClientDelegate>)client;

@end
