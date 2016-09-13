//
//  YYDelayButton.m
//  YYDownloadManager
//
//  Created by 杨振 on 16/9/13.
//  Copyright © 2016年 yangzhen5352. All rights reserved.
//

#import "YYDelayButton.h"
static NSTimeInterval defaultDuration = 2.0f;

// 是否忽略的事件
static BOOL _isIgnoreEvent = NO;

// 重置状态
static void resetState() {
    
    _isIgnoreEvent = NO;
}

@implementation YYDelayButton

// 发送方法到哪里 在什么事件下
- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if ([self isKindOfClass:[UIButton class]]) {
        
        self.clickDurationTime = self.clickDurationTime == 0 ? defaultDuration : self.clickDurationTime;
        
        if (_isIgnoreEvent) {
            
            return;
        }
        else if (self.clickDurationTime > 0) {
            
            _isIgnoreEvent = YES;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.clickDurationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                resetState();
            });
            
            [super sendAction:action to:target forEvent:event];
        }
    }
    else {
        
        [super sendAction:action to:target forEvent:event];
    }
}


@end
