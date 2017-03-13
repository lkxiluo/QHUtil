//
//  QHBackgroundTimerManager.h
//  QHUtil
//
//  Created by QianHan on 2017/3/3.
//  Copyright © 2017年 karl.luo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 延长程序在后台运行的时间，确保计时器等能在后台依旧运行
 */
@interface QHBackgroundTimerManager : NSObject

+ (instancetype)qh_shareInstance;

/**
 开启后台运行模式
 */
- (void)qh_openBackgroundRunning;

/**
 关闭后台运行模式
 */
- (void)qh_stopBackgroundRunning;

@end
