//
//  GWLCustomSlider.m
//  GWLCustomSlider
//
//  Created by 高万里 on 15/6/6.
//  Copyright (c) 2015年 高万里. All rights reserved.
//

#import "GWLCustomSlider.h"
#import "UIView+Add.h"

#define kPADDING  0.5 // 按钮间距
#define kMARGIN   10  // 边距
@interface GWLCustomSlider ()

@property(nonatomic,strong)NSArray *titleArray;
/**min按钮默认显示的下标*/
@property(nonatomic,assign)NSInteger defalutMinValueIndex;
/**max按钮默认显示的下标*/
@property(nonatomic,assign)NSInteger defalutMaxValueIndex;
/**最小值和最大值是否可以一样*/
@property(nonatomic,assign)BOOL minMaxCanSame;

@property(nonatomic,weak)UIView *sliderView;
@property(nonatomic,weak)UIButton *minSliderButton;
@property(nonatomic,weak)UIButton *maxSliderButton;
/**标题Label数组*/
@property(nonatomic,strong)NSMutableArray *titleLabelArray;
/**一个刻度的长度*/
@property(nonatomic,assign)CGFloat scale;

@end

@implementation GWLCustomSlider

+ (instancetype)customSliderWithTitleArray:(NSArray *)titleArray withDefalutMinValueIndex:(NSInteger)defalutMinValueIndex withDefalutMaxValueIndex:(NSInteger)defalutMaxValueIndex andMinMaxCanSame:(BOOL)minMaxCanSame {
    return [[self alloc]initWithTitleArray:titleArray withDefalutMinValueIndex:defalutMinValueIndex withDefalutMaxValueIndex:defalutMaxValueIndex andMinMaxCanSame:minMaxCanSame];
}

- (instancetype)initWithTitleArray:(NSArray *)titleArray withDefalutMinValueIndex:(NSInteger)defalutMinValueIndex withDefalutMaxValueIndex:(NSInteger)defalutMaxValueIndex andMinMaxCanSame:(BOOL)minMaxCanSame {
    if (self = [super init]) {
        self.backgroundColor = [UIColor lightGrayColor];
        [self makeSubviews];
        _defalutMinValueIndex = defalutMinValueIndex;
        _defalutMaxValueIndex = defalutMaxValueIndex;
        _minMaxCanSame = minMaxCanSame;
        self.titleArray = titleArray;
    }
    return self;
}

- (void)makeSubviews {
    UIView *sliderView = [[UIView alloc]init];
    sliderView.backgroundColor = [UIColor grayColor];
    [self addSubview:sliderView];
    self.sliderView = sliderView;
    
    UIButton *minSliderButton = [[UIButton alloc]init];
    minSliderButton.backgroundColor = [UIColor whiteColor];
    [minSliderButton setImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
    [minSliderButton setImage:[UIImage imageNamed:@"blue"] forState:UIControlStateHighlighted];
    [minSliderButton setImage:[UIImage imageNamed:@"blue"] forState:UIControlStateSelected];
    minSliderButton.showsTouchWhenHighlighted = YES;
    UIPanGestureRecognizer *minSliderButtonPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMinSliderButton:)];
    [minSliderButton addGestureRecognizer:minSliderButtonPanGestureRecognizer];
    [sliderView addSubview:minSliderButton];
    self.minSliderButton = minSliderButton;
    
    UIButton *maxSliderButton = [[UIButton alloc]init];
    maxSliderButton.backgroundColor = [UIColor whiteColor];
    [maxSliderButton setImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
    [maxSliderButton setImage:[UIImage imageNamed:@"red"] forState:UIControlStateHighlighted];
    [maxSliderButton setImage:[UIImage imageNamed:@"red"] forState:UIControlStateSelected];
    maxSliderButton.showsTouchWhenHighlighted = YES;
    UIPanGestureRecognizer *maxSliderButtonPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMaxSliderButton:)];
    [maxSliderButton addGestureRecognizer:maxSliderButtonPanGestureRecognizer];
    [sliderView addSubview:maxSliderButton];
    self.maxSliderButton = maxSliderButton;
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    for (NSString *title in _titleArray) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.textColor = [UIColor lightGrayColor];
        titleLabel.font = [UIFont systemFontOfSize:12.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        [self addSubview:titleLabel];
        [self.titleLabelArray addObject:titleLabel];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger titleLabelCount = self.titleLabelArray.count;
    
    if (titleLabelCount == 0) {
        return;
    }
    
    CGFloat contentW = self.width-2*kMARGIN; // 内容宽度
    CGFloat titleLabelW = (contentW-(titleLabelCount-1)*kPADDING)/titleLabelCount;
    self.scale = titleLabelW;// 每个刻度的宽度
    UILabel *lastLabel;
    for (NSInteger index = 0; index < titleLabelCount; index++ ) {
        UILabel *titleLabel = self.titleLabelArray[index];
        titleLabel.X = kMARGIN + index*(titleLabelW+kPADDING);
        titleLabel.Y = kMARGIN;
        titleLabel.width = titleLabelW;
        titleLabel.height = 12;
        if (index == titleLabelCount-1) {
            lastLabel = titleLabel;
        }
    }
    
    CGFloat sliderViewH = 0;
    if (_minSliderButton.currentImage != nil) {
        sliderViewH = _minSliderButton.currentImage.size.height*(titleLabelW/_minSliderButton.currentImage.size.width);
    }
    _sliderView.frame = CGRectMake(kMARGIN, CGRectGetMaxY(lastLabel.frame)+kPADDING, contentW, sliderViewH);
    
    _minSliderButton.X = _defalutMinValueIndex*(titleLabelW+kPADDING);
    _minSliderButton.width = titleLabelW;
    _minSliderButton.height = sliderViewH;
    
    _maxSliderButton.frame = _minSliderButton.frame;
    _maxSliderButton.X = _defalutMaxValueIndex*(titleLabelW+kPADDING);
    
    self.height = CGRectGetMaxY(_sliderView.frame)+kMARGIN;
    
    [self valueChanged];
}

/**minSlider拖动事件*/
- (void)panMinSliderButton:(UIPanGestureRecognizer *)pan {
    CGPoint panPoint = [pan translationInView:pan.view];
    [pan setTranslation:CGPointZero inView:pan.view];
    
    CGFloat toX = self.minSliderButton.X + panPoint.x;
    CGFloat panMaxX = 0;
    if (_minMaxCanSame) {
        panMaxX = self.maxSliderButton.X; // 可重叠
    }else {
        panMaxX = self.maxSliderButton.X-self.minSliderButton.width-kPADDING; // 不能重叠
    }
    
    int a = (int)ceil(toX/_scale); // 表示滑动了几个刻度的距离
    float b = (toX/_scale) - ((int)floor(toX/_scale));
    if (toX >= 0 && toX <= panMaxX) {
        self.minSliderButton.X = toX;
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (ABS(b) > 0.5) {
            toX = a*(_scale+kPADDING);
        }else {
            toX = (a-1)*(_scale+kPADDING);
        }
        if (toX >= 0 && toX <= panMaxX) {
            self.minSliderButton.X = toX;
        }else {
            if (toX < 0) {
                toX = 0;
            }else if (toX > panMaxX) {
                toX = panMaxX;
            }
            self.minSliderButton.X = toX;
        }
        
        if (self.minSliderButton.X == self.maxSliderButton.X) {
            [self.sliderView sendSubviewToBack:self.maxSliderButton];
        }
        [self valueChanged];
    }
}

/**maxSlider拖动事件*/
- (void)panMaxSliderButton:(UIPanGestureRecognizer *)pan {
    CGPoint panPoint = [pan translationInView:pan.view];
    [pan setTranslation:CGPointZero inView:pan.view];
    
    CGFloat toX = self.maxSliderButton.X + panPoint.x;
    CGFloat panMaxX = self.sliderView.width - self.maxSliderButton.width;
    
    CGFloat minX = 0;
    if (_minMaxCanSame) {
        minX = self.minSliderButton.X; // 可重叠
    }else {
        minX = CGRectGetMaxX(self.minSliderButton.frame)+kPADDING; // 不可重叠
    }
    
    int a = (int)ceil(toX/_scale); // 表示滑动了几个刻度的距离
    float b = (toX/_scale) - ((int)floor(toX/_scale));
    if (toX >= minX && toX <= panMaxX) {
        self.maxSliderButton.X = toX;
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (ABS(b) > 0.5) {
            toX = a*(_scale+kPADDING);
        }else {
            toX = (a-1)*(_scale+kPADDING);
        }
        if (toX >= minX && toX <= panMaxX) {
            self.self.maxSliderButton.X = toX;
        }else {
            if (toX < minX) {
                toX = 0;
            }else if (toX > panMaxX) {
                toX = panMaxX;
            }
            self.self.maxSliderButton.X = toX;
        }
        if (self.maxSliderButton.X == self.minSliderButton.X) {
            [self.sliderView sendSubviewToBack:self.minSliderButton];
        }
        [self valueChanged];
    }
}

- (void)valueChanged {
    if ([self.delegate respondsToSelector:@selector(customSliderValueChanged:minValue:maxValue:)]) {
        NSString *minValue = _titleArray[(int)(self.minSliderButton.X/(_scale+kPADDING))];
        NSString *maxValue = _titleArray[(int)(self.maxSliderButton.X/(_scale+kPADDING))];
        [self.delegate customSliderValueChanged:self minValue:minValue maxValue:maxValue];
    }
}

- (NSMutableArray *)titleLabelArray {
    if (!_titleLabelArray) {
        _titleLabelArray = [NSMutableArray array];
    }
    return _titleLabelArray;
}

@end
