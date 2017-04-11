//
//  C2sClient.h
//  tim
//
//  Created by Main on 2017/3/16.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import "IfaceImpl.h"
#import "ConnectDelegate.h"

@interface C2sClient : IfaceImpl

+ (instancetype)newInstance:(id<ConnectDelegate>)connect;


@end
