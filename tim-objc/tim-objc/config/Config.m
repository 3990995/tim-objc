//
//  Config.m
//  tim
//
//  Created by Main on 2017/3/16.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import "Config.h"
#import <UIKit/UIKit.h>

@implementation Config

- (instancetype)init{
    self = [super init];
    if (self) {
        self.ENCODE = @"utf-8";
        self.NS = @"iostim";
        self.VERSION = [timConstants protocolversionName];
        self.domain = @"donnie4w@gmail.com";
        self.ip = @"127.0.0.1";
        self.port = 3737;
        self.heartBeat = 30;
        self.reconnectionAllowed = YES;
        self.connectTimeout = 10000;
        self.resource = [self deviceInfo];
        self.TLS = NO;
        self.TsslPort = 5757;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    Config *config = [[[self class] allocWithZone:zone] init];
    config.ENCODE = self.ENCODE;
    config.NS = self.NS;
    config.VERSION = self.VERSION;
    config.domain = self.domain;
    config.ip = self.ip;
    config.port = self.port;
    config.heartBeat = self.heartBeat;
    config.reconnectionAllowed = self.reconnectionAllowed;
    config.connectTimeout = self.connectTimeout;
    config.resource = self.resource;
    config.TLS = self.TLS;
    config.TsslPort = self.TsslPort;
    config.loginName = self.loginName;
    config.password = self.password;
    //    model->_nickName = _nickName;//未公开的成员
    return config;
}


- (NSString *)deviceInfo {
    static NSString *info;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIDevice *device = [[UIDevice alloc] init];
        NSString *name = device.name;       //获取设备所有者的名称
        NSString *model = device.model;      //获取设备的类别
        NSString *type = device.localizedModel; //获取本地化版本
        NSString *systemName = device.systemName;   //获取当前运行的系统
        NSString *systemVersion = device.systemVersion;//获取当前系统的版本
        info = [NSString stringWithFormat:@"%@|%@|%@|%@|%@",model,systemName,systemVersion,type,name];
    });
    return info;
}


@end
