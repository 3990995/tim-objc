//
//  TPClient.m
//  tim
//
//  Created by Main on 2017/3/21.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import "TPClient.h"
#import "ClientProxy.h"

@implementation TPClient

+ (instancetype)newInstance:(Config *)config {
    return [[TPClient alloc] initWithConfig:config];
}

- (instancetype)initWithConfig:(Config *)config {
    self = [super init];
    if (self) {
        self.config = config;
    }
    return self;
}

- (id)getClient:(id<ClientDelegate>)target {
    return [[ClientProxy newInstance:self.config] withObject:target];
}

@end
