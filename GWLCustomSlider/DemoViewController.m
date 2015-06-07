//
//  DemoViewController.m
//  GWLCustomSlider
//
//  Created by 高万里 on 15/6/6.
//  Copyright (c) 2015年 高万里. All rights reserved.
//

#import "DemoViewController.h"
#import "GWLCustomSlider.h"

@interface DemoViewController () <GWLCustomSliderDelegate>

@property(nonatomic,weak)GWLCustomSlider *customSlider;
@property(nonatomic,weak)UILabel *sliderValueLabel;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"CustomSlider";
    
    NSArray *titleArray = @[@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80",@"90",@"100",@"更多"];
    GWLCustomSlider *customSlider = [GWLCustomSlider customSliderWithTitleArray:titleArray withDefalutMinValueIndex:0 withDefalutMaxValueIndex:5 andMinMaxCanSame:YES];
    customSlider.frame = CGRectMake(10, 100, kSCREENW-20, 0);
    customSlider.delegate = self;
    [self.view addSubview:customSlider];
    self.customSlider = customSlider;
}

#pragma mark - CustomSliderDelegate
- (void)customSliderValueChanged:(GWLCustomSlider *)slider minValue:(NSString *)minValue maxValue:(NSString *)maxValue {
    self.sliderValueLabel.text = [NSString stringWithFormat:@"范围：%@ - %@",minValue,maxValue];
}

- (UILabel *)sliderValueLabel {
    if (!_sliderValueLabel) {
        UILabel *sliderValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.customSlider.frame)+10, kSCREENW-20, 44)];
        sliderValueLabel.textColor = [UIColor whiteColor];
        sliderValueLabel.backgroundColor = [UIColor lightGrayColor];
        sliderValueLabel.font = [UIFont systemFontOfSize:15.0];
        sliderValueLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:sliderValueLabel];
        _sliderValueLabel = sliderValueLabel;
    }
    return _sliderValueLabel;
}

@end