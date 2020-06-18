//
//  ViewController.m
//  StopWatch
//
//  Created by yyn on 2020/6/18.
//  Copyright © 2020 iDaily. All rights reserved.
//

#import "ViewController.h"
#import "TimeTableViewCell.h"
#import "TimeModel.h"
#import "UIImage+Color.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *historyBtn;


@property (nonatomic, strong) TimeTableViewCell *currentTimeCell;
@property (nonatomic, strong) TimeModel *timeData;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval totalTime;
@property (nonatomic, assign) NSTimeInterval rowInterval;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTime];
    [self setupSubViews];
}

- (IBAction)resetClick:(UIButton *)sender {
    if (sender.selected) { // 复位
           
        [self dataArchive];
        [self initTime];
        [self.tableView reloadData];
       
        sender.enabled = NO;
        sender.selected = NO;
       
    } else { // 计次
       
        self.rowInterval = 0;
        [self.timeData recordCountWithCompletion:nil];
    }
   
    [self.tableView reloadData];
}

- (IBAction)startClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        if (!self.resetBtn.enabled){ //启动
            self.resetBtn.enabled = YES;
            self.historyBtn.hidden = true;
            [self initTime];
        } else {
            self.resetBtn.selected = NO;
        }
        
        __weak typeof(self) weakSelf = self;
        if (self.timeData.isReset) {
            [self.timeData recordCountWithCompletion:^{
                [weakSelf.tableView reloadData];
            }];
        }
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
            weakSelf.totalTime++;
            weakSelf.rowInterval++;
            weakSelf.timeLab.text = [weakSelf convertTime:weakSelf.totalTime];
            
            if (weakSelf.currentTimeCell != [weakSelf topCell]) {
                weakSelf.currentTimeCell = [weakSelf topCell];
            }
            
            weakSelf.currentTimeCell.detailTextLabel.text = [weakSelf convertTime:weakSelf.rowInterval];
            [weakSelf.timeData updateTime:weakSelf.rowInterval];
            
        }];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    } else {
        self.resetBtn.selected = YES;
        [_timer invalidate];
    }
    
}

- (IBAction)historyClick:(id)sender {
    
    [self initTime];
    self.resetBtn.enabled = NO;
    self.startBtn.selected = NO;
    self.timeData = [self getArchiveData];
    [self.tableView reloadData];
    
}

#pragma mark archive
- (void)dataArchive {
    NSString *docDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [docDirectory stringByAppendingPathComponent:@"time.data"];
    [NSKeyedArchiver archiveRootObject:self.timeData toFile:filePath];
    if (self.historyBtn.hidden) {
        self.historyBtn.hidden = NO;
    }
}

- (TimeModel *)getArchiveData {
    NSString *docDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [docDirectory stringByAppendingPathComponent:@"time.data"];
    TimeModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return model;
}


#pragma tableView -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell"];
    if (!cell) {
        cell = [[TimeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TimeCell"];
    }

    [cell reloadData:self.timeData atIndexPath:indexPath];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.timeData.times.count;
}

- (TimeTableViewCell *)topCell{
    return [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (NSString *)convertTime:(NSUInteger)time{
    return [NSString stringWithFormat:@"%02ld:%02ld.%02ld",time / 100 / 60, time / 100 % 60, time % 100];;
}

#pragma mark init
- (void)setupSubViews {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    TimeModel *historyModel = [self getArchiveData];
    if (historyModel.times.count > 0) {
        self.historyBtn.hidden = false;
    }else {
        self.historyBtn.hidden = true;
    }
    
    [self.resetBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.08 green:0.08 blue:0.08 alpha:1]] forState:UIControlStateDisabled];
    
    [self.resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.resetBtn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateSelected];
    [self.resetBtn setBackgroundImage:[self.resetBtn backgroundImageForState:UIControlStateSelected] forState:UIControlStateNormal];
    
    [self.startBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:20 / 255.0 green:40 / 255.0 blue:24 / 255.0 alpha:1]] forState:UIControlStateNormal];
    [self.startBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:74 / 255.0 green:16 / 255.0 blue:17 / 255.0 alpha:1]] forState:UIControlStateSelected];

}

- (void)initTime{
    self.totalTime = 0;
    self.rowInterval = 0;
    self.timeLab.text = @"00:00.00";
    self.timeData = [[TimeModel alloc] init];
}

@end
