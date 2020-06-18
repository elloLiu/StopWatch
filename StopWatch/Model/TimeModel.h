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

// 是否处于复位状态
@property (nonatomic,assign,readonly) BOOL isReset;
@property (nonatomic,strong,readonly) NSArray<NSNumber *> * times;

// 当不存在时，返回-1
@property (nonatomic,assign,readonly)NSInteger maxIndex;
@property (nonatomic,assign,readonly)NSInteger minIndex;

- (void)recordCountWithCompletion:(nullable void(^)(void))completion;
- (void)updateTime:(NSTimeInterval)time;
- (void)reset;

@end

NS_ASSUME_NONNULL_END
