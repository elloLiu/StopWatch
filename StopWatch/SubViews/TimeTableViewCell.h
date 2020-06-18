//
//  TimeTableViewCell.h
//  StopWatch
//
//  Created by yyn on 2020/6/18.
//  Copyright © 2020 iDaily. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TimeModel;

@interface TimeTableViewCell : UITableViewCell

- (void)reloadData:(TimeModel *)data atIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
