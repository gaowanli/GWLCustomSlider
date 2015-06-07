//
//  ViewController.m
//  CustomSlider
//
//  Created by 高万里 on 15/6/6.
//  Copyright (c) 2015年 高万里. All rights reserved.
//

#import "ViewController.h"
#import "DemoViewController.h"

@interface ViewController ()

@property(nonatomic,weak)UISlider *intValueSlider;
@property(nonatomic,weak)UILabel *intValueLabel;

@property(nonatomic,weak)UISlider *floatValueSlider;
@property(nonatomic,weak)UILabel *floatValueLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"UISlider";
    
    UISlider *intValueSlider = [[UISlider alloc]initWithFrame:CGRectMake(10, 100, kSCREENW-20, 44)];
    intValueSlider.maximumValue = 100;
    intValueSlider.minimumValue = 10;
    [intValueSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:intValueSlider];
    self.intValueSlider = intValueSlider;
    self.intValueLabel.text = @"0";
    
    UISlider *floatValueSlider = [[UISlider alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.intValueLabel.frame)+10, kSCREENW-20, 44)];
    floatValueSlider.maximumValue = 100;
    floatValueSlider.minimumValue = 10;
    [floatValueSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:floatValueSlider];
    self.floatValueSlider = floatValueSlider;
    self.floatValueLabel.text = @"0.00";
    
    UIBarButtonItem *nextBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(nextBarButtonItemDidClick)];
    self.navigationItem.rightBarButtonItem = nextBarButtonItem;
}

- (void)sliderValueChanged:(UISlider *)slider {
    float floatValue = slider.value;
    if (slider == self.floatValueSlider) {
        self.floatValueLabel.text = [NSString stringWithFormat:@"%.2lf",slider.value];
        return;
    }
    
    int intValue = (int)ceilf(floatValue);
    int setValue = 0;
    if (intValue%10 < 5) {
        setValue = intValue/10*10;
    }else{
        setValue = (intValue/10+1) *10;
    }
    [slider setValue:(float)setValue];
    self.intValueLabel.text = [NSString stringWithFormat:@"%d",(int)slider.value];
}

- (void)nextBarButtonItemDidClick {
    DemoViewController *customSliderViewController = [[DemoViewController alloc]init];
    [self.navigationController pushViewController:customSliderViewController animated:YES];
}

- (UILabel *)intValueLabel {
    if (!_intValueLabel) {
        UILabel *intValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.intValueSlider.frame)+10, kSCREENW-20, 44)];
        intValueLabel.textColor = [UIColor whiteColor];
        intValueLabel.backgroundColor = [UIColor lightGrayColor];
        intValueLabel.font = [UIFont systemFontOfSize:15.0];
        intValueLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:intValueLabel];
        _intValueLabel = intValueLabel;
    }
    return _intValueLabel;
}

- (UILabel *)floatValueLabel {
    if (!_floatValueLabel) {
        UILabel *floatValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.floatValueSlider.frame)+10, kSCREENW-20, 44)];
        floatValueLabel.textColor = [UIColor whiteColor];
        floatValueLabel.backgroundColor = [UIColor lightGrayColor];
        floatValueLabel.font = [UIFont systemFontOfSize:15.0];
        floatValueLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:floatValueLabel];
        _floatValueLabel = floatValueLabel;
    }
    return _floatValueLabel;
}

@end