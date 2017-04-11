//
//  TimUtils.h
//  tim
//
//  Created by Main on 2017/3/18.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TIMService.h"
#import "Config.h"
#import "ConnectDelegate.h"

@interface TimUtils : NSObject

+ (Tid *)newTid:(NSString *)loginName config:(Config *)config tidType:(TidEnum)tidType;

+ (TimMBean *)newTimMBean:(NSString *)toName msg:(NSString *)msg tidType:(TidEnum)tidType config:(Config *)config;

+ (NSString *)threadId;

@end
