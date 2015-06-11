//
//  GWLCustomSliderNew.h
//  GWLCustomSliderNew
//
//  Created by 高万里 on 15/6/11.
//  Copyright (c) 2015年 高万里. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWLCustomSliderNew;
@protocol GWLCustomSliderNewDelegate <NSObject>

/**
 *  slider值改变的代理方法
 *
 *  @param slider   slider
 *  @param minValue 最小值
 *  @param maxValue 最大值
 */
- (void)customSliderValueChanged:(GWLCustomSliderNew *)slider minValue:(NSString *)minValue maxValue:(NSString *)maxValue;

@end

@interface GWLCustomSliderNew : UIView

/**
 *  初始化一个slider
 *
 *  @param defalutMinValue      初始化显示的最小值
 *  @param defalutMaxValue      初始化显示的最大值
 *  @param minMaxCanSame        最小值和最大值是否可以一样
 */
+ (instancetype)customSliderWithDefalutMinValue:(float)defalutMinValue withDefalutMaxValue:(float)defalutMaxValue andMinMaxCanSame:(BOOL)minMaxCanSame;

@property(nonatomic,weak)id<GWLCustomSliderNewDelegate> delegate;

@end
