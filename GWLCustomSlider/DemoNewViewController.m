//
//  DemoNewViewController.m
//  GWLCustomSlider
//
//  Created by Gaowl on 15/6/11.
//  Copyright (c) 2015年 高万里. All rights reserved.
//

#import "DemoNewViewController.h"
#import "UIView+Add.h"
#import "GWLCustomSliderNew.h"

@interface DemoNewViewController () <GWLCustomSliderNewDelegate>

@property(nonatomic, weak) GWLCustomSliderNew *customSlider;
@property(nonatomic,weak)UILabel *sliderValueLabel;

@end

@implementation DemoNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"第二版 CustomSlider";
    
    GWLCustomSliderNew *customSlider = [GWLCustomSliderNew customSliderWithDefalutMinValue:12 withDefalutMaxValue:75 andMinMaxCanSame:YES];
    customSlider.frame = CGRectMake(10, 100, kSCREENW-20, 100);
    customSlider.delegate = self;
    [self.view addSubview:customSlider];
    self.customSlider = customSlider;
}

#pragma mark - GWLCustomSliderNewDelegate
- (void)customSliderValueChanged:(GWLCustomSliderNew *)slider minValue:(NSString *)minValue maxValue:(NSString *)maxValue
{
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
