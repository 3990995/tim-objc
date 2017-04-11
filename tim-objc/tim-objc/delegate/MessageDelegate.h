//
//  MessageDelegate.h
//  tim 是服务器推送message的监听接口 ，接收好友或群的信息 
//
//  Created by Main on 2017/3/16.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TIMService.h"

@protocol MessageDelegate <NSObject>

- (void)processMessage:(TimMBean *)mbean;
- (void)processMessages:(NSMutableArray<TimMBean *> *)mbeans;
- (void)loadMessage:(TimMBean *)mbean;

@end
