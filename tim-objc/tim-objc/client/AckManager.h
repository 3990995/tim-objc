//
//  AckManager.h
//  tim
//
//  Created by Main on 2017/3/20.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AckDelegate.h"
#import "ClientDelegate.h"
#import "TIMService.h"

@interface AckManager : NSObject<AckDelegate>

@property (nonatomic, weak) id<ClientDelegate> client;

+ (instancetype)defaultManager:(id<ClientDelegate>)client;

@end
