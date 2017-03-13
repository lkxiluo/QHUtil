//
//  QHBackgroundTimerManager.m
//  QHUtil
//
//  Created by QianHan on 2017/3/3.
//  Copyright © 2017年 karl.luo. All rights reserved.
//

#import "QHBackgroundTimerManager.h"
#import <UIKit/UIKit.h>

@interface QHBackgroundTimerManager ()

@property (nonatomic, assign) __block UIBackgroundTaskIdentifier taskId;

@end

@implementation QHBackgroundTimerManager

static QHBackgroundTimerManager *timerManager = nil;
static dispatch_once_t onceToken;
+ (instancetype)qh_shareInstance {
    dispatch_once(&onceToken, ^{
        timerManager = [[QHBackgroundTimerManager alloc] init];
    });
    return timerManager;
}

- (void)qh_openBackgroundRunning {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backgroundopen)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backgroundstop)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)backgroundopen {
    UIApplication *app = [UIApplication sharedApplication];
    self.taskId = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.taskId != UIBackgroundTaskInvalid) {
                self.taskId = UIBackgroundTaskInvalid;
            }
        });
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.taskId != UIBackgroundTaskInvalid) {
                self.taskId = UIBackgroundTaskInvalid;
            }
        });
    });
}

- (void)backgroundstop {
    
    UIApplication *app = [UIApplication sharedApplication];
    [app endBackgroundTask:self.taskId];
}

- (void)qh_stopBackgroundRunning {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    timerManager = nil;
    onceToken = 0l;
    [self backgroundstop];
}

@end
