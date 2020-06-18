//
//  TimeModel.m
//  StopWatch
//
//  Created by yyn on 2020/6/18.
//  Copyright © 2020 iDaily. All rights reserved.
//

#import "TimeModel.h"

@interface TimeModel()

@property (nonatomic,strong) NSArray<NSNumber *> * times;
@property (nonatomic,assign) BOOL isReset;
@property (nonatomic,assign)NSInteger maxIndex;
@property (nonatomic,assign)NSInteger minIndex;

@end

@implementation TimeModel
{
    NSMutableArray<NSNumber *> *_times;
}

#pragma mark initial
- (instancetype)init{
    if (self = [super init]) {
        [self reset];
    }
    
    return self;
}

#pragma mark coding
- (void)encodeWithCoder:(NSCoder *)coder{
    
    [coder encodeBool:self.isReset forKey:@"isReset"];
    [coder encodeObject:self.times forKey:@"times"];
    [coder encodeInteger:self.maxIndex forKey:@"maxIndex"];
    [coder encodeInteger:self.minIndex forKey:@"minIndex"];
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    if ([super init]) {
        self.isReset = [coder decodeBoolForKey:@"isReset"];
        self.times = [coder decodeObjectForKey:@"times"];
        self.maxIndex = [coder decodeIntegerForKey:@"maxIndex"];
        self.minIndex = [coder decodeIntegerForKey:@"minIndex"];
    }
    return self;
}


#pragma mark method
- (void)reset{
    _isReset = YES;
    _isHistory = NO;
    _times = [NSMutableArray array];
}

- (void)recordCountWithCompletion:( void (^)(void))completion{
    [_times insertObject:@0 atIndex:0];
    _isReset = NO;
    
    if (completion) {
        completion();
    }
}

- (void)updateTime:(NSTimeInterval)time{
    [_times replaceObjectAtIndex:0 withObject:@(time)];
}

- (void)setIsHistory:(BOOL)isHistory{
    _isHistory = isHistory;
    _maxIndex = [self maxIndex];
    _minIndex = [self minIndex];
}

#pragma mark index
- (NSInteger)maxIndex{
    if (_times.count <= 2) {
        return -1;
    }
    
    // 默认第0行是正在run的数据，不做比较，所以 max默认为1，begin为2
    // 历史数据时要比较所有数据，max = 0，begin = 0
    
    int maxIndex = _isHistory ? 0 : 1;
    int beginIndex = _isHistory ? 0 : 2;
    for (int i = beginIndex; i < _times.count; i++) {
        if ([_times[i] intValue] > [_times[maxIndex] intValue]) {
            maxIndex = i;
        }
    }
    return maxIndex;
}

- (NSInteger)minIndex{
    if (_times.count<= 2) {
        return -1;
    }
    
    int minIndex = _isHistory ? 0 : 1;
    int beginIndex = _isHistory ? 0 : 2;
    for (int i = beginIndex; i < _times.count; i++) {
        if ([_times[i] intValue] < [_times[minIndex] intValue]) {
            minIndex = i;
        }
    }
    return minIndex;
}

@end
