//
//  TimeModel.h
//  StopWatch
//
//  Created by yyn on 2020/6/18.
//  Copyright © 2020 iDaily. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeModel : NSObject<NSCoding>

// 复位
@property (nonatomic,assign,readonly) BOOL isReset;
@property (nonatomic,strong,readonly) NSArray<NSNumber *> * times;

// 默认-1
@property (nonatomic,assign,readonly)NSInteger maxIndex;
@property (nonatomic,assign,readonly)NSInteger minIndex;

// history
@property (nonatomic,assign) BOOL isHistory;

- (void)recordCountWithCompletion:(nullable void(^)(void))completion;
- (void)updateTime:(NSTimeInterval)time;
- (void)reset;

@end

NS_ASSUME_NONNULL_END
