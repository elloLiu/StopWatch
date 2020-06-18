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

#pragma mark index
- (NSInteger)maxIndex{
    if (_times.count <= 2) {
        return -1;
    }
    
    int maxIndex = 1;
    for (int i = 2; i < _times.count; i++) {
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
    
    int minIndex = 1;
    for (int i = 2; i < _times.count; i++) {
        if ([_times[i] intValue] < [_times[minIndex] intValue]) {
            minIndex = i;
        }
    }
    return minIndex;
}

@end
