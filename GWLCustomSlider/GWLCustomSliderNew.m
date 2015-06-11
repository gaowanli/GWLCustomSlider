//
//  GWLCustomSliderNew.m
//  GWLCustomSliderNew.m
//
//  Created by 高万里 on 15/6/10.
//  Copyright (c) 2015年 高万里. All rights reserved.
//

#import "GWLCustomSliderNew.h"
#import "UIView+Add.h"

#define kMARGIN     10  // 边距
#define kCOLORBLUE  ([UIColor colorWithRed:69/255.0f green:135/255.0f blue:195/255.0f alpha:1.0])

@interface GWLCustomSliderNew ()

@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,assign)NSInteger defalutMinValue;
@property(nonatomic,assign)NSInteger defalutMaxValue;
/**最小值和最大值是否可以一样*/
@property(nonatomic,assign)BOOL minMaxCanSame;

@property(nonatomic,weak)UIView *sliderView;
@property(nonatomic,weak)UILabel *backgroundIndicatorLabel;
@property(nonatomic,weak)UILabel *indicatorLabel;
@property(nonatomic,weak)UIButton *minSliderButton;
@property(nonatomic,weak)UIButton *maxSliderButton;
/**标题Label数组*/
@property(nonatomic,strong)NSMutableArray *titleLabelArray;
/**一个刻度的长度*/
@property(nonatomic,assign)CGFloat scale;
/**完成了一次布局*/
@property(nonatomic,assign)BOOL layoutOnceDone;

@end

@implementation GWLCustomSliderNew

+ (instancetype)customSliderWithDefalutMinValue:(float)defalutMinValue withDefalutMaxValue:(float)defalutMaxValue andMinMaxCanSame:(BOOL)minMaxCanSame{
    return [[self alloc]initWithDefalutMinValue:defalutMinValue withDefalutMaxValue:defalutMaxValue andMinMaxCanSame:minMaxCanSame];
}

- (instancetype)initWithDefalutMinValue:(float)defalutMinValue withDefalutMaxValue:(float)defalutMaxValue andMinMaxCanSame:(BOOL)minMaxCanSame {
    if (self = [super init]) {
        [self makeSubviews];
        self.backgroundColor = [UIColor whiteColor];
        _defalutMinValue = defalutMinValue;
        _defalutMaxValue = defalutMaxValue;
        _minMaxCanSame = minMaxCanSame;
    }
    return self;
}

- (void)makeSubviews {
    for (NSString *title in self.titleArray) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = [UIColor lightGrayColor];
        titleLabel.font = [UIFont systemFontOfSize:12.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        [self addSubview:titleLabel];
        [self.titleLabelArray addObject:titleLabel];
    }
    
    UIView *sliderView = [[UIView alloc]init];
    [self addSubview:sliderView];
    self.sliderView = sliderView;
    
    UILabel *backgroundIndicatorLabel = [[UILabel alloc]init];
    backgroundIndicatorLabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:backgroundIndicatorLabel];
    self.backgroundIndicatorLabel = backgroundIndicatorLabel;
    
    UILabel *indicatorLabel = [[UILabel alloc]init];
    indicatorLabel.backgroundColor = kCOLORBLUE;
    [self addSubview:indicatorLabel];
    self.indicatorLabel = indicatorLabel;
    
    UIButton *minSliderButton = [[UIButton alloc]init];
    [minSliderButton setImage:[UIImage imageNamed:@"icon_jiage.png"] forState:UIControlStateNormal];
    [minSliderButton setImage:[UIImage imageNamed:@"icon_jiage.png"] forState:UIControlStateHighlighted];
    [minSliderButton setImage:[UIImage imageNamed:@"icon_jiage.png"] forState:UIControlStateSelected];
    UIPanGestureRecognizer *minSliderButtonPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMinSliderButton:)];
    [minSliderButton addGestureRecognizer:minSliderButtonPanGestureRecognizer];
    [sliderView addSubview:minSliderButton];
    self.minSliderButton = minSliderButton;
    
    UIButton *maxSliderButton = [[UIButton alloc]init];
    [maxSliderButton setImage:[UIImage imageNamed:@"icon_jiage.png"] forState:UIControlStateNormal];
    [maxSliderButton setImage:[UIImage imageNamed:@"icon_jiage.png"] forState:UIControlStateHighlighted];
    [maxSliderButton setImage:[UIImage imageNamed:@"icon_jiage.png"] forState:UIControlStateSelected];
    UIPanGestureRecognizer *maxSliderButtonPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMaxSliderButton:)];
    [maxSliderButton addGestureRecognizer:maxSliderButtonPanGestureRecognizer];
    [sliderView addSubview:maxSliderButton];
    self.maxSliderButton = maxSliderButton;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_layoutOnceDone) {
        return;
    }
    NSInteger titleLabelCount = self.titleLabelArray.count;
    
    CGFloat contentW = self.width-2*kMARGIN; // 内容宽度
    CGFloat titleLabelW = contentW/titleLabelCount;
    self.scale = titleLabelW;// 每个刻度的宽度
    UILabel *lastLabel;
    for (NSInteger index = 0; index < titleLabelCount; index++ ) {
        UILabel *titleLabel = self.titleLabelArray[index];
        titleLabel.X = kMARGIN + index*titleLabelW;
        titleLabel.Y = kMARGIN;
        titleLabel.width = titleLabelW;
        titleLabel.height = 12;
        if (index == titleLabelCount-1) {
            lastLabel = titleLabel;
        }
    }
    
    CGFloat labelW = contentW - _scale*0.5*2;
    _backgroundIndicatorLabel.frame = CGRectMake(kMARGIN+_scale*0.5, CGRectGetMaxY(lastLabel.frame)+4, labelW, 4);
    _backgroundIndicatorLabel.layer.cornerRadius = _backgroundIndicatorLabel.height*0.5;
    _backgroundIndicatorLabel.layer.masksToBounds = YES;
    _indicatorLabel.Y = _backgroundIndicatorLabel.Y;
    _indicatorLabel.size = _backgroundIndicatorLabel.size;
    _indicatorLabel.layer.cornerRadius = _indicatorLabel.height*0.5;
    _indicatorLabel.layer.masksToBounds = YES;
    
    CGFloat sliderViewH = 0;
    if (_minSliderButton.currentImage != nil) {
        sliderViewH = _minSliderButton.currentImage.size.height*(titleLabelW/_minSliderButton.currentImage.size.width);
    }
    _sliderView.frame = CGRectMake(kMARGIN, CGRectGetMaxY(_backgroundIndicatorLabel.frame), contentW, sliderViewH);
    
    _minSliderButton.X = _defalutMinValue*_scale*0.1;
    _minSliderButton.width = titleLabelW;
    _minSliderButton.height = sliderViewH;
    
    _maxSliderButton.frame = _minSliderButton.frame;
    _maxSliderButton.X = _defalutMaxValue*_scale*0.1;
    
    [self configureIndicatorLableXW];
    
    [self valueChanged];
}

/**minSlider拖动事件*/
- (void)panMinSliderButton:(UIPanGestureRecognizer *)pan {
    CGPoint panPoint = [pan translationInView:pan.view];
    [pan setTranslation:CGPointZero inView:pan.view];
    
    NSInteger toX = ceil(self.minSliderButton.X + panPoint.x);
    CGFloat panMaxX = 0;
    if (_minMaxCanSame) {
        panMaxX = self.maxSliderButton.X; // 可重叠
    }else {
        panMaxX = self.maxSliderButton.X-self.minSliderButton.width; // 不能重叠
    }
    
    if (toX >= 0 && toX <= panMaxX) {
        self.minSliderButton.X = toX;
    }
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        [self valueChanged];
    }else if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.minSliderButton.X == self.maxSliderButton.X) {
            [self.sliderView sendSubviewToBack:self.maxSliderButton];
        }
    }
}

/**maxSlider拖动事件*/
- (void)panMaxSliderButton:(UIPanGestureRecognizer *)pan {
    CGPoint panPoint = [pan translationInView:pan.view];
    [pan setTranslation:CGPointZero inView:pan.view];
    
    NSInteger toX = ceil(self.maxSliderButton.X + panPoint.x);
    CGFloat panMaxX = self.sliderView.width - self.maxSliderButton.width;
    
    CGFloat minX = 0;
    if (_minMaxCanSame) {
        minX = self.minSliderButton.X; // 可重叠
    }else {
        minX = CGRectGetMaxX(self.minSliderButton.frame); // 不可重叠
    }
    
    if (toX >= minX && toX <= panMaxX) {
        self.maxSliderButton.X = toX;
    }
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        [self valueChanged];
    }else if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.maxSliderButton.X == self.minSliderButton.X) {
            [self.sliderView sendSubviewToBack:self.minSliderButton];
        }
    }
}

- (void)valueChanged {
    
    [self configureIndicatorLableXW];
    
    CGFloat minX = self.minSliderButton.X;
    NSInteger minValue = ceil(minX/_scale*10);
    
    CGFloat maxX = self.maxSliderButton.X;
    NSInteger maxValue = ceil(maxX/_scale*10);
    
    if ([self.delegate respondsToSelector:@selector(customSliderValueChanged:minValue:maxValue:)]) {
        [self.delegate customSliderValueChanged:self minValue:[NSString stringWithFormat:@"%zd.0",minValue] maxValue:[NSString stringWithFormat:@"%zd.0",maxValue]];
    }
}

/**设置指示条的范围*/
- (void)configureIndicatorLableXW
{
    CGFloat indicatorMinX = self.minSliderButton.X+_scale*0.5;
    self.indicatorLabel.X = kMARGIN+indicatorMinX;
    self.indicatorLabel.width = CGRectGetMaxX(self.maxSliderButton.frame)-_scale*0.5-indicatorMinX;
    _layoutOnceDone = YES;
}

#pragma mark - layz laoding
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"0",@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80",@"90",@"100"];
    }
    return _titleArray;
}

- (NSMutableArray *)titleLabelArray {
    if (!_titleLabelArray) {
        _titleLabelArray = [NSMutableArray array];
    }
    return _titleLabelArray;
}

@end
