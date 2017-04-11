//
//  TimUtils.m
//  tim
//
//  Created by Main on 2017/3/18.
//  Copyright © 2017年 TIM. All rights reserved.
//

#import "TimUtils.h"

@implementation TimUtils

+ (Tid *)newTid:(NSString *)loginName config:(Config *)config tidType:(TidEnum)tidType {
    Tid *tid = [Tid new];
    [tid setDomain:config.domain];
    [tid setName:loginName];
    if (tidType == Group) {
        [tid setType:stringWithLiteral(Group)];
    }else{
        [tid setType:stringWithLiteral(Normal)];
    }
    return tid;
}

+ (TimMBean *)newTimMBean:(NSString *)toName msg:(NSString *)msg tidType:(TidEnum)tidType config:(Config *)config {
    TimMBean *mb = [TimMBean new];
    [mb setBody:msg];
    [mb setToTid:[TimUtils newTid:toName config:config tidType:tidType]];
    [mb setThreadId:[TimUtils threadId]];
    [mb setType:@"chat"];
    return mb;
}

+ (NSString *)threadId {
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970] * 1000 * 1000;
    return [NSString stringWithFormat:@"%lld",recordTime];
}

@end
