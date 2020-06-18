//
//  TimeTableViewCell.m
//  StopWatch
//
//  Created by yyn on 2020/6/18.
//  Copyright © 2020 iDaily. All rights reserved.
//

#import "TimeTableViewCell.h"
#import "TimeModel.h"

@implementation TimeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor blackColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.detailTextLabel.textColor = [UIColor whiteColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:17.0];
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.userInteractionEnabled = NO;
    }
    return self;
    
}

- (void)reloadData:(TimeModel *)data atIndexPath:(NSIndexPath *)indexPath{
    
    self.textLabel.textColor = [UIColor whiteColor];
    self.detailTextLabel.textColor = [UIColor whiteColor];

    self.textLabel.text = [NSString stringWithFormat:@"计次 %lu", data.times.count - indexPath.row];

    NSUInteger time = [data.times[indexPath.row] integerValue];

    self.detailTextLabel.text = [self convertTime:time];
    
    
    if (indexPath.row == data.maxIndex) {
        self.textLabel.textColor = [UIColor redColor];
        self.detailTextLabel.textColor = [UIColor redColor];
    }

    if (indexPath.row == data.minIndex) {
        self.textLabel.textColor = [UIColor greenColor];
        self.detailTextLabel.textColor = [UIColor greenColor];
    }
    
}

- (NSString *)convertTime:(NSUInteger)time{
    return [NSString stringWithFormat:@"%02ld:%02ld.%02ld",time / 100 / 60, time / 100 % 60, time % 100];;
}

@end
