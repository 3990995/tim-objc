//
//  ClientSub.h
//  tim
//
//  Created by Main on 2017/3/16.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientDelegate.h"
#import "ConnectImpl.h"
#import "Config.h"

@interface ClientSub : NSObject<ClientDelegate>

@property (nonatomic, strong) ConnectImpl *connect;
@property (nonatomic, strong) Config *cconfig;
@property (nonatomic, assign) Flow cflow;
@property (nonatomic, assign) BOOL valid;

/**!
 * @brief 创建client的工厂方法
 *
 * @param client 委托
 *
 * @exception TimException
 *
 * @return 实例对象
 */
+ (instancetype)newClient:(id<ClientDelegate>)client;

/**!
 * @brief 创建client的工厂方法
 *
 * @param client 委托
 * @param config 配置对象
 *
 * @exception TimException
 *
 * @return 实例对象
 */
+ (instancetype)newClient:(id<ClientDelegate>)client config:(Config *)config;



@end
