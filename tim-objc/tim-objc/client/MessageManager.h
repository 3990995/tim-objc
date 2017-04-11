//
//  MessageManager.h
//  tim 消息处理器
//
//  Created by Main on 2017/3/20.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageDelegate.h"
#import "Singleton.h"

@interface MessageManager : NSObject<MessageDelegate>

//+ (instancetype)defaultManager;

SingletonDeclare


@end
