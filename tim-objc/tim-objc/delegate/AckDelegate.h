//
//  AckDelegate.h
//  tim 是服务器ack回复的监听接口 ，登陆成功后的服务器反馈信息等
//
//  Created by Main on 2017/3/16.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TIMService.h"

@protocol AckDelegate <NSObject>

- (void)processAck:(TimAckBean *)ab;

@end
