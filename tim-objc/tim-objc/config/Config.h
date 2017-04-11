//
//  Config.h
//  tim IM配置类
//
//  Created by Main on 2017/3/16.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TIMService.h"

@interface Config : NSObject<NSCopying>

/// 编码
@property (nonatomic,copy) NSString *ENCODE;

/// 命名空间
@property (nonatomic,copy) NSString *NS;

/// 协议版本
@property (nonatomic,copy) NSString *VERSION;

/// 域名，客户端标识，相当于appid 在登陆时需要设置
@property (nonatomic,copy) NSString *domain;

/// 连接服务器ip地址
@property (nonatomic,copy) NSString *ip;

/// 连接服务器端口
@property (nonatomic,assign) int port;

/// 心跳时间 （秒）
@property (nonatomic,assign) int heartBeat;

/// 是否断开重连，默认开启（秒）
@property (nonatomic,assign,getter=isReconnectionAllowed) BOOL reconnectionAllowed;

/// 连接超时时间 （毫秒）
@property (nonatomic,assign) int connectTimeout;

/// 客户端来源标识，可以是手机型号例如 huaweip9 
@property (nonatomic,copy) NSString *resource;

/// 登录名
@property (nonatomic,copy) NSString *loginName;

/// 密码
@property (nonatomic,copy) NSString *password;

/// 是否用TLS传输
@property (nonatomic,assign,getter=isTLS) BOOL TLS;

/// 服务器TLS端口
@property (nonatomic,assign) int TsslPort;

@end
