//
//  ClientFactory.h
//  tim
//
//  Created by Main on 2017/3/18.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientDelegate.h"
#import "Config.h"

@interface ClientFactory : NSObject

+ (id<ClientDelegate>)getClient:(Config *)config;

+ (id<ClientDelegate>)getClient:(id<ClientDelegate>)client config:(Config *)config;

@end
