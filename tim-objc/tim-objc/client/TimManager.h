//
//  TimManager.h
//  tim
//
//  Created by gossip2 on 17/4/5.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "Config.h"

@interface TimManager : NSObject

SingletonDeclare

- (void)loginWithConfig:(Config *)config;

@end
