//
//  YSRunningRecordViewController.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSRunningRecordViewController.h"
#import "YSRunningGeneralModeView.h"
#import "YSRunningMapModeView.h"
#import "YSRunningResultViewController.h"
#import "YSTimeManager.h"

@interface YSRunningRecordViewController () <YSRunningModeViewDelegate, YSTimeManagerDelegate>

@property (nonatomic, strong) YSRunningGeneralModeView *runningGeneralModeView;
@property (nonatomic, strong) YSRunningMapModeView *runningMapModeView;
@property (nonatomic, strong) YSRunningModeView *currentModeView;
@property (nonatomic, strong) YSTimeManager *timeManager;

@end

@implementation YSRunningRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addModeView];
    [self initTimeManager];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)addModeView
{
    self.runningGeneralModeView = [[YSRunningGeneralModeView alloc] init];
    self.runningGeneralModeView.delegate = self;
    [self.view addSubview:self.runningGeneralModeView];
    
    self.runningMapModeView = [[YSRunningMapModeView alloc] init];
    self.runningMapModeView.delegate = self;
    [self.view addSubview:self.runningMapModeView];
    
    self.currentModeView = self.runningGeneralModeView;
    [self.view bringSubviewToFront:self.currentModeView];
}

- (void)initTimeManager
{
    self.timeManager = [YSTimeManager new];
    self.timeManager.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.timeManager start];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.runningGeneralModeView resetLayoutWithFrame:[self getModeViewFrame]];
    [self.runningMapModeView resetLayoutWithFrame:[self getModeViewFrame]];
}

- (CGRect)getModeViewFrame
{
    CGFloat originY = 20;
    CGRect frame = CGRectMake(0, originY, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - originY);
    
    return frame;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - YSRunningModeViewDelegate

- (void)changeMode
{
    BOOL isPause = self.currentModeView.isPause;
    if ([self.currentModeView isKindOfClass:[YSRunningGeneralModeView class]])
    {
        self.currentModeView = self.runningMapModeView;
    }
    else
    {
        self.currentModeView = self.runningGeneralModeView;
    }
    
    self.currentModeView.isPause = isPause;
    [self.currentModeView resetButtonsPositionWithPauseStatus];
    [self.view bringSubviewToFront:self.currentModeView];
}

- (void)runningPause
{
    [self.timeManager pause];
}

- (void)runningContinue
{
    [self.timeManager start];
}

- (void)runningFinish
{
    YSRunningResultViewController *resultViewController = [YSRunningResultViewController new];
    [self.navigationController pushViewController:resultViewController animated:YES];
}

#pragma mark - YSTimeManagerDelegate

- (void)tickWithAccumulatedTime:(NSUInteger)time
{
    [self.runningGeneralModeView resetTimeLabelWithTime:time];
    [self.runningMapModeView resetTimeLabelWithTime:time];
}

@end
