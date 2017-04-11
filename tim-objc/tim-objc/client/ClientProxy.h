//
//  ClientProxy.h
//  tim
//
//  Created by Main on 2017/3/21.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientDelegate.h"
#import "Config.h"

@interface ClientProxy : NSProxy<ClientDelegate>

@property (nonatomic, strong) Config *config;

+ (instancetype)newInstance:(Config *)config;

- (id)withObject:(id<ClientDelegate>)client;

@end
