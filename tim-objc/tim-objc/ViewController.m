//
//  ViewController.m
//  test
//
//  Created by Main on 2017/3/21.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import "ViewController.h"
#import "TimManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    Config *config = [Config new];
    config.domain = @"服务器定义";
    config.heartBeat = 40;
    config.ip = @"ip或者域名";
    config.port = 6666;
    config.loginName = @"test";
    config.password = @"test";

    [[TimManager defaultManager] loginWithConfig:config];

}


@end
