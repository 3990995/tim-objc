//
//  ITimImpl.h
//  tim
//
//  Created by Main on 2017/3/18.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import "IfaceImpl.h"
#import "ConnectDelegate.h"
#import "ClientDelegate.h"
#import "C2sClient.h"

@interface ITimImpl : IfaceImpl

@property (nonatomic, weak) id<ConnectDelegate> connect;
@property (nonatomic, weak) id<ClientDelegate> client;

- (instancetype)initWithConnect:(id<ConnectDelegate>)connect client:(id<ClientDelegate>)client;

@end
