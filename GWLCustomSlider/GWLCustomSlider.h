//
//  GWLCustomSlider.h
//  GWLCustomSlider
//
//  Created by 高万里 on 15/6/6.
//  Copyright (c) 2015年 高万里. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWLCustomSlider;
@protocol GWLCustomSliderDelegate <NSObject>

/**
 *  slider值改变的代理方法
 *
 *  @param slider   slider
 *  @param minValue 最小值
 *  @param maxValue 最大值
 */
- (void)customSliderValueChanged:(GWLCustomSlider *)slider minValue:(NSString *)minValue maxValue:(NSString *)maxValue;

@end

@interface GWLCustomSlider : UIView

/**
 *  初始化一个slider
 *
 *  @param titleArray           标题数组
 *  @param defalutMinValueIndex 初始化显示的最小值index
 *  @param defalutMaxValueIndex 初始化显示的最大值index
 *  @param minMaxCanSame        最小值和最大值是否可以一样
 */
+ (instancetype)customSliderWithTitleArray:(NSArray *)titleArray withDefalutMinValueIndex:(NSInteger)defalutMinValueIndex withDefalutMaxValueIndex:(NSInteger)defalutMaxValueIndex andMinMaxCanSame:(BOOL)minMaxCanSame;

@property(nonatomic,weak)id<GWLCustomSliderDelegate> delegate;

@end
