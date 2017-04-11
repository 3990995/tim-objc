//
//  MessageManager.m
//  tim
//
//  Created by Main on 2017/3/20.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import "MessageManager.h"

@implementation MessageManager

SingletonImplementation

- (void)processMessage:(TimMBean *)mbean {
    NSLog(@"type:%@",mbean.type); //chat
    NSLog(@"msgType:%d",mbean.msgType); //// 1 文字 2图片 3音频 4视频
    NSLog(@"body:%@",mbean.body);
    NSLog(@"mid:%@",mbean.mid);
    NSLog(@"date:%@",mbean.timestamp);
    NSLog(@"name:%@",mbean.toTid.name);
    NSLog(@"Timtime:%@",mbean.offline);
    NSLog(@"extraList:%@",mbean.extraList);
}

- (void)processMessages:(NSMutableArray<TimMBean *> *)mbeans {
    if (mbeans != nil && mbeans.count > 0) {
        for (TimMBean *tm in mbeans) {
            [self processMessage:tm];
        }
    }
}

- (void)loadMessage:(TimMBean *)mbean {
    NSLog(@"%@",mbean);
}

@end
