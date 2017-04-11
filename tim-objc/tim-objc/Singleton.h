//
//  Singleton.h
//  tim 帮助实现单例设计模式
//
//  Created by Main on 2017/3/20.
//  Copyright © 2017年 TIM. All rights reserved.
//

#define SingletonDeclare + (instancetype)defaultManager;

#define SingletonImplementation                             \
static id sharedSingleton = nil;                            \
+ (id)allocWithZone:(struct _NSZone *)zone {                \
    if (sharedSingleton == nil) {                           \
        static dispatch_once_t onceToken;                   \
        dispatch_once(&onceToken, ^{                        \
            sharedSingleton = [super allocWithZone:zone];   \
        });                                                 \
    }                                                       \
    return sharedSingleton;                                 \
}                                                           \
- (id)init {                                                \
    static dispatch_once_t onceToken;                       \
    dispatch_once(&onceToken, ^{                            \
        sharedSingleton = [super init];                     \
    });                                                     \
    return sharedSingleton;                                 \
}                                                           \
+ (instancetype)defaultManager {                            \
    return [[self alloc] init];                             \
}                                                           \
+ (id)copyWithZone:(struct _NSZone *)zone {                 \
    return sharedSingleton;                                 \
}                                                           \
+ (id)mutableCopyWithZone:(struct _NSZone *)zone {          \
    return sharedSingleton;                                 \
}
