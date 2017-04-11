//
//  TimEnum.h
//  tim
//
//  Created by Main on 2017/3/20.
//  Copyright © 2017年 TIM. All rights reserved.
//
#define stringWithLiteral(literal) @#literal

typedef NS_ENUM(NSUInteger, FlowConnect) {
    Start,  // 流程开始，connect
    Run,    // 业务接口调用，process完成
    Stop,   // 流程结束
};

typedef NS_ENUM(NSUInteger, Flow) {
    Connect,    // 连接
    Auth,       // 业务接口调用，登陆完成
    AuthUnPass, // 验证未通过
    Disconnect  // 连接关闭
};

typedef NS_ENUM(NSUInteger, TidEnum) {
    Normal,
    Group,
};

typedef NS_ENUM(NSUInteger, TimType) {
    Login,
    Ping,
    Message,
    Presence,
    Other
};

