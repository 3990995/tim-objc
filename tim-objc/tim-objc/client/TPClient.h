//
//  TPClient.h
//  tim
//
//  Created by Main on 2017/3/21.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import "ClientDelegate.h"

@interface TPClient : NSObject

@property (nonatomic, strong) Config *config;

+ (instancetype)newInstance:(Config *)config;

- (id)getClient:(id<ClientDelegate>)target;

@end
