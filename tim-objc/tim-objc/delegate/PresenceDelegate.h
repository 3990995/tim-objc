//
//  PresenceDelegate.h
//  tim 是用户在线状态的监听接口 ，如好友上下线或离开等状态
//
//  Created by Main on 2017/3/16.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TIMService.h"

@protocol PresenceDelegate <NSObject>

- (void)processPresence:(TimPBean *)pbean;

@end
