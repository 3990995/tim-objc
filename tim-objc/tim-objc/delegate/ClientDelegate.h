//
//  Client.h
//  主要的操作接口  ：提供 login , sendMessage ,close 等方法
//
//  Created by Main on 2017/3/16.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TIMService.h"
#import "MessageDelegate.h"
#import "PresenceDelegate.h"
#import "AckDelegate.h"
#import "ConnectDelegate.h"
#import "Config.h"

@protocol ClientDelegate <NSObject>

/**
 * @brief 登陆
 *
 * @param name 登录账号
 * @param pwd  密码
 *
 * @exception TimException
 */
- (void)login:(NSString *)name pwd:(NSString *)pwd;

/**
 * @brief 发送消息
 *
 * @param msg       消息内容
 * @param toName    目标用户
 * @param tidType   用户类型
 *
 * @exception TimException
 */
- (void)sendMessage:(NSString *)msg toName:(NSString *)toName tidType:(TidEnum)tidType;

/// 关闭
- (void)close;

/// 注册消息监听器
- (void)addMessageDelegate:(id<MessageDelegate>)delegate;

/// 注册出席协议监听器
- (void)addPresenceDelegate:(id<PresenceDelegate>)delegate;

/// 注册回执监听器
- (void)addAckDelegate:(id<AckDelegate>)delegate;

///是否已经连接
- (BOOL)isConnect;

/// 是否已经登陆
- (BOOL)isLogin;

/// 设置流程节点
- (void)setFlow:(Flow)flow;

/// 获得流程节点
- (Flow)flow;

/// 获得配置
- (Config *)config;

/// 是否有效
- (BOOL)isValid;

/**
 * @brief 加载信息
 *
 * @param toNameList    用户数组,数组中的用户都加载聊天记录
 * @param fromStamp     开始时间戳
 * @param toStamp       结束时间戳
 * @param limitCount    每页多少记录
 *
 * @exception TimException
 */
- (void)loadMessageByNameList:(NSMutableArray<NSString *> *)toNameList fromStamp:(NSString *)fromStamp toStamp:(NSString *)toStamp limitCount:(int)limitCount;

/**
 * @brief 删除信息
 *
 * @param toName   目标用户
 * @param mid      消息id
 *
 * @exception TimException
 */
- (void)delMessageByName:(NSString *)toName mid:(NSString *)mid;
- (void)delAllMessageByName:(NSString *)toName;

- (void)setValid:(BOOL)valid;
- (void)addPing;
- (void)initPing;
- (void)proessError:(BOOL)error;

@end
