//
//  ViewController.m
//  MikaEqualizer
//
//  Created by Mika on 16/8/25.
//  Copyright © 2016年 Mika. All rights reserved.
//

#import "ViewController.h"
#import "TheAmazingAudioEngine.h"
#import "AEHighPassFilter.h"
#import "AEParametricEqFilter.h"

@interface ViewController ()
@property (nonatomic, strong) AEAudioController *audioController;
@property (nonatomic, strong) AEHighPassFilter *filter;
@property (nonatomic, strong) AEAudioFilePlayer *player;
@property (nonatomic, strong) NSMutableArray *seliderArr;
@end

@implementation ViewController{
    AEParametricEqFilter *_eq20HzFilter;
    AEParametricEqFilter *_eq50HzFilter;
    AEParametricEqFilter *_eq100HzFilter;
    AEParametricEqFilter *_eq200HzFilter;
    AEParametricEqFilter *_eq500HzFilter;
    AEParametricEqFilter *_eq1kFilter;
    AEParametricEqFilter *_eq2kFilter;
    AEParametricEqFilter *_eq5kFilter;
    AEParametricEqFilter *_eq10kFilter;
    AEParametricEqFilter *_eq20kFilter;
    NSArray * _eqFilters;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.seliderArr = [NSMutableArray array];
    // Do any additional setup after loading the view, typically from a nib.
    self.audioController = [[AEAudioController alloc] initWithAudioDescription:AEAudioStreamBasicDescriptionNonInterleaved16BitStereo inputEnabled:YES];//
    NSError *error = NULL;
    BOOL result = [_audioController start:&error];
    if ( !result ) {
        NSLog(@"发生错误:%@",error);
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"specialPeople" ofType:@"mp3"];
    self.player = [[AEAudioFilePlayer alloc] initWithURL:[NSURL fileURLWithPath:path] error:&error];
    //设置高通音效
    //    [self setupFilterHighPass:100];
    //创建音效
    [self creatEqFliters];
    //初始化视图
    [self setSubViews];
}

//初始化音效赫兹
- (void)creatEqFliters {
    _eq20HzFilter  = [[AEParametricEqFilter alloc] init];
    _eq50HzFilter  = [[AEParametricEqFilter alloc] init];
    _eq100HzFilter = [[AEParametricEqFilter alloc] init];
    _eq200HzFilter = [[AEParametricEqFilter alloc] init];
    _eq500HzFilter = [[AEParametricEqFilter alloc] init];
    _eq1kFilter    = [[AEParametricEqFilter alloc] init];
    _eq2kFilter    = [[AEParametricEqFilter alloc] init];
    _eq5kFilter    = [[AEParametricEqFilter alloc] init];
    _eq10kFilter   = [[AEParametricEqFilter alloc] init];
    _eq20kFilter   = [[AEParametricEqFilter alloc] init];
    _eqFilters     = @[_eq20HzFilter, _eq50HzFilter, _eq100HzFilter, _eq200HzFilter, _eq500HzFilter, _eq1kFilter, _eq2kFilter, _eq5kFilter, _eq10kFilter, _eq20kFilter];
}
//初始化视图
- (void)setSubViews {
    NSArray *arr = [NSArray arrayWithObjects:@"20HZ",@"50HZ",@"100HZ",@"200HZ",@"500HZ",@"1000HZ",@"2000HZ",@"5000HZ",@"10000HZ",@"20000HZ",@"🔊 音量", nil];
    CGFloat margin = 30;
    for (int i = 0; i < 11; i++) {
        
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, margin*(i+1)+20*i, 200, 20)];
        slider.tag = 1000 + i;
        slider.minimumValue = -5.0;
        slider.maximumValue = 5.0;
        slider.value = 0.0;
        slider.backgroundColor = [UIColor purpleColor];
        if (i == 10) {
            slider.minimumValue = 0.0;
            slider.maximumValue = 5.0;
            slider.value = 2.0;
            [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        }else{
            [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventTouchUpInside];
            [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventTouchUpOutside];
            [self.seliderArr addObject:slider];
        }
        [self.view addSubview:slider];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(slider.frame) + 10, CGRectGetMinY(slider.frame), 100, 20)];
        lab.text = [NSString stringWithFormat:@"%@",arr[i]];
        lab.backgroundColor = [UIColor grayColor];
        lab.textColor = [UIColor blueColor];
        [self.view addSubview:lab];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 110, CGRectGetHeight(self.view.frame) - 70, 100, 60);
    [button setTitle:@"重置音效" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor grayColor];
    [button addTarget:self action:@selector(resetButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.audioController addChannels:@[self.player]];
}

//重置音效事件
- (void)resetButtonAction:(UIButton *)btn {
    for (UISlider *slider in self.seliderArr) {
        slider.value = 0.0;
        [self sliderValueChange:slider];
    }
}

//改变音效
- (void)sliderValueChange:(UISlider *)slider {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGFloat value = slider.value;
        NSLog(@"滑块：%lf",value);
        NSInteger eqType = 20;
        switch (slider.tag) {
            case 1000:{
                
                break;
            }
            case 1001:{
                eqType = 50;
                break;
            }
            case 1002:{
                eqType = 100;
                break;
            }
            case 1003:{
                eqType = 200;
                break;
            }
            case 1004:{
                eqType = 500;
                break;
            }
            case 1005:{
                eqType = 1000;
                break;
            }
            case 1006:{
                eqType = 2000;
                break;
            }
            case 1007:{
                eqType = 5000;
                break;
            }case 1008:{
                eqType = 10000;
                break;
            }case 1009:{
                eqType = 20000;
                break;
            }
                
            default: {
                self.player.volume = value;
                break;
            }
        }
        [self setupFilterEq:eqType value:value];
    });
}

//#pragma mark 高通音效
//- (void)setupFilterHighPass:(double)cutoffFrequency {
//    // 创建并添加AEAudioUnitFilter实例
//    [self addHighpassFilter];
//
//    // 设置相关属性值，达到音效的控制
//    self.filter.cutoffFrequency = cutoffFrequency;
//}
//
//- (void)addHighpassFilter {
//    // _highPassFilter是AEHighPassFilter类的实例
//    // AEHighPassFilter是AEAudioUnitFilter的子类
//    if (!self.filter) {
//        self.filter = [[AEHighPassFilter alloc] init];
//        [self.audioController addFilter:self.filter];
//    } else {
//        if ( ![self.audioController.filters containsObject:self.filter] ) {
//            [self.audioController addFilter:self.filter];
//        }
//    }
//    [self.audioController addChannels:@[self.player]];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//改变音效
- (void)setupFilterEq:(NSInteger)eqType value:(double)gain {
    switch (eqType) {
        case 20: {
            // 设置需要调整的频率，并将传入的增益值gain赋值给gain属性，达到音效调整效果
            [self setupEqFilter:_eq20HzFilter centerFrequency:20 gain:gain];
            break;
        }
        case 50: {
            [self setupEqFilter:_eq50HzFilter centerFrequency:50 gain:gain];
            break;
        }
        case 100: {
            [self setupEqFilter:_eq100HzFilter centerFrequency:100 gain:gain];
            break;
        }
        case 200: {
            [self setupEqFilter:_eq200HzFilter centerFrequency:200 gain:gain];
            break;
        }
        case 500: {
            [self setupEqFilter:_eq500HzFilter centerFrequency:500 gain:gain];
            break;
        }
        case 1000: {
            [self setupEqFilter:_eq1kFilter centerFrequency:1000 gain:gain];
            break;
        }
        case 2000: {
            [self setupEqFilter:_eq2kFilter centerFrequency:2000 gain:gain];
            break;
        }
        case 5000: {
            [self setupEqFilter:_eq5kFilter centerFrequency:5000 gain:gain];
            break;
        }
        case 10000: {
            [self setupEqFilter:_eq10kFilter centerFrequency:10000 gain:gain];
            break;
        }
        case 20000: {
            [self setupEqFilter:_eq20kFilter centerFrequency:20000 gain:gain];
            break;
        }
    }
}

- (void)setupEqFilter:(AEParametricEqFilter *)eqFilter centerFrequency:(double)centerFrequency gain:(double)gain {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if ( ![_audioController.filters containsObject:eqFilter] ) {
            for (AEParametricEqFilter *existEqFilter in _eqFilters) {
                if (eqFilter == existEqFilter) {
                    [self.audioController addFilter:eqFilter];
                    
                    break;
                }
            }
        }
        
        eqFilter.centerFrequency = centerFrequency;
        eqFilter.qFactor         = 1.0;
        eqFilter.gain            = gain;
    });
}
@end
