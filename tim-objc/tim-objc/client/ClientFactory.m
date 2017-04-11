//
//  ClientFactory.m
//  tim
//
//  Created by Main on 2017/3/18.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import "ClientFactory.h"
#import "ClientImpl.h"

@implementation ClientFactory

+ (id<ClientDelegate>)getClient:(Config *)config {
    return [ClientImpl newClient:config];
}

+ (id<ClientDelegate>)getClient:(id<ClientDelegate>)client config:(Config *)config {
    if (client != nil) {
        [client close];
    }
    return [ClientFactory getClient:config];
}

@end
