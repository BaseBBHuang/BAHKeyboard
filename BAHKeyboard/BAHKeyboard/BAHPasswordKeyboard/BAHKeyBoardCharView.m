//
//  KeyBoardCharView.m
//
//  Created by 乔贝斯 on 2017/3/28.
//  Copyright © 2017年 BAH. All rights reserved.
//

#import "BAHKeyBoardCharView.h"
#import "BAHPassWordKeyBoard.h"

#define plusInch ([UIScreen mainScreen].bounds.size.height > 700)


@interface BAHKeyBoardCharView ()
{
    float space_x;//按钮竖间距
    float space_y;//按钮行间距
    float btn_height;//按钮的高度
    float offset_X2;//第三行的x坐标
    float thirRowY;//第三行的y坐标
}

/** 字符按钮*/
@property (nonatomic, copy)NSArray *charCollections;

/** 切换大小写*/
@property (strong, nonatomic) UIButton *shiftButton;
/** 删除 */
@property (strong, nonatomic) UIButton *delButton;
/** 切换数字 */
@property (strong, nonatomic) UIButton *switch123Button;
/** 切换字符 */
@property (strong, nonatomic) UIButton *switchSymbolButton;
/** 空格 */
@property (strong, nonatomic) UIButton *spaceButton;
/** 当前是否是小写字母 */
@property (nonatomic, assign) BOOL isLow;
/** 高亮按钮 */
@property (strong, nonatomic) UIImageView *imageViewButton;


@end

@implementation BAHKeyBoardCharView

- (id)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:frame])
    {
        self.isLow = NO;
        //布局按钮
        [self setupLayoutButton];
    }
    return self;
}

#pragma mark - 布局
- (void)setupLayoutButton
{
    //按钮布局
    [self setupLettersButton];
    //切换大小写按钮
    [self setupShiftButton];
    //删除按钮
    [self setupDeleteButton];
    //最后一行
    [self setupLastButton];
    //大小初始化
    [self switchKeyBoard];
}

#pragma mark - 布局字母按钮
- (void)setupLettersButton
{
    space_x = 2;
    space_y = 7;
    //第一行布局 10个按钮
    float btn_width = (self.frame.size.width-space_x*11)/10;
    btn_height = (self.frame.size.height-space_y*5)/4;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<10; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(space_x+(space_x+btn_width)*i, space_y, btn_width, btn_height);
        [self addSubview:btn];
        [array addObject:btn];
    }
    
    //第二行布局 9个按钮
    float offset_X = (self.frame.size.width-9*btn_width-8*space_x)/2;
    for (NSInteger i=0; i<9; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(offset_X+(space_x+btn_width)*i, btn_height+space_y+space_y, btn_width, btn_height);
        [self addSubview:btn];
        [array addObject:btn];
    }
    
    //第三行布局
    offset_X2 = (self.frame.size.width-7*btn_width-6*space_x)/2;
    thirRowY = btn_height*2+space_y+space_y*2;
    for (NSInteger i=0; i<7; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(offset_X2+(space_x+btn_width)*i, thirRowY, btn_width, btn_height);
        [self addSubview:btn];
        
        [array addObject:btn];
    }
    self.charCollections = [[NSArray alloc] initWithArray:array];
    //为字母键盘添加图片和事件
    UIImage *img = [UIImage imageNamed:@"key_normal"];
    
    for (int i = 0; i < self.charCollections.count; i++)
    {
        UIButton *button = [self.charCollections objectAtIndex:i];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [button setBackgroundImage:img forState:UIControlStateNormal];
        [button setTitle:[self.lowerDataSource objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onLettersClick:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(onLettersClick:) forControlEvents:UIControlEventTouchUpOutside];
        [button addTarget:self action:@selector(onLettersClickDown:) forControlEvents:UIControlEventTouchDown];
        [button setExclusiveTouch:YES];
    }

}

- (void)setupShiftButton
{
    self.shiftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shiftButton setBackgroundImage:[UIImage imageNamed:@"key_fat_bg_blue"] forState:UIControlStateNormal];
    [self.shiftButton setImage:[UIImage imageNamed:@"key_icon_shift_normal"] forState:UIControlStateNormal];
    [self.shiftButton setImage:[UIImage imageNamed:@"key_icon_shift_highlighted"] forState:UIControlStateHighlighted];
    [self.shiftButton setImage:[UIImage imageNamed:@"key_icon_shift_highlighted"] forState:UIControlStateSelected];
    self.shiftButton.frame = CGRectMake(space_x, thirRowY, offset_X2-space_x-space_y, btn_height);
    [self addSubview:self.shiftButton];
    [self.shiftButton addTarget:self action:@selector(onShiftClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupDeleteButton
{
    self.delButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.delButton setBackgroundImage:[UIImage imageNamed:@"key_fat_bg_blue"] forState:UIControlStateNormal];
    [self.delButton setImage:[UIImage imageNamed:@"key_icon_del"] forState:UIControlStateNormal];
    self.delButton.frame = CGRectMake(self.frame.size.width-self.shiftButton.frame.size.width-space_x, thirRowY, offset_X2-space_x-space_y, btn_height);
    [self.delButton addTarget:self action:@selector(onDeleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.delButton];

}

- (void)setupLastButton
{
    //左右两个按钮的宽度 第四行
    float btn4_width = self.frame.size.width/3-40;
    //切换数字
    self.switch123Button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switch123Button.frame = CGRectMake(space_x, thirRowY+space_y+btn_height, btn4_width, btn_height);
    self.switch123Button.layer.cornerRadius = 8;
    [self.switch123Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.switch123Button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.switch123Button.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.switch123Button setTitle:@"123" forState:UIControlStateNormal];
    [self.switch123Button setBackgroundImage:[UIImage imageNamed:@"key_mood_normal"] forState:UIControlStateNormal];
    [self.switch123Button setBackgroundImage:[UIImage imageNamed:@"key_mood_pressed"] forState:UIControlStateHighlighted];
    [self.switch123Button addTarget:self action:@selector(onSwitchNumbersClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.switch123Button];
    
    //空格
    self.spaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.spaceButton.frame = CGRectMake(2*space_x+btn4_width, thirRowY+space_y+btn_height, self.frame.size.width-btn4_width*2-4*space_x, btn_height);
    self.spaceButton.layer.cornerRadius = 8;
    [self.spaceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.spaceButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.spaceButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.spaceButton setTitle:@"空 格" forState:UIControlStateNormal];
    [self.spaceButton setBackgroundImage:[UIImage imageNamed:@"key_space_normal"] forState:UIControlStateNormal];
    [self.spaceButton setBackgroundImage:[UIImage imageNamed:@"key_space_pressed"] forState:UIControlStateHighlighted];
    [self addSubview:self.spaceButton];
    
    
    //#+=
    self.switchSymbolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchSymbolButton.frame = CGRectMake(self.frame.size.width-btn4_width-space_x, thirRowY+space_y+btn_height, btn4_width, btn_height);
    [self.switchSymbolButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.switchSymbolButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.switchSymbolButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.switchSymbolButton.layer.cornerRadius = 8;
    [self.switchSymbolButton setTitle:@"#+=" forState:UIControlStateNormal];
    [self.switchSymbolButton setBackgroundImage:[UIImage imageNamed:@"key_mood_normal"] forState:UIControlStateNormal];
    [self.switchSymbolButton setBackgroundImage:[UIImage imageNamed:@"key_mood_pressed"] forState:UIControlStateHighlighted];
    [self.switchSymbolButton addTarget:self action:@selector(onSwitchSymbolsClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.switchSymbolButton];

}

#pragma mark - 初始化小写键盘数据
- (void)initLowerKeyBoard
{
    self.isLow = YES;
    for (int i = 0; i < self.charCollections.count; i++)
    {
        UIButton *button = [self.charCollections objectAtIndex:i];
        [button setTitle:[self.lowerDataSource objectAtIndex:i] forState:UIControlStateNormal];
    }
}

#pragma mark - 初始化大写键盘数据
- (void)initUpperKeyBoard
{
    self.isLow = NO;
    for (int i = 0; i < self.charCollections.count; i++)
    {
        UIButton *button = [self.charCollections objectAtIndex:i];
        [button setTitle:[self.upperDataSource objectAtIndex:i] forState:UIControlStateNormal];
    }
}

#pragma mark - 切换大小方法
- (void)switchKeyBoard
{
    self.isLow = !self.isLow;
    if (self.isLow)
    {
        [self initLowerKeyBoard];
    }
    else
    {
        [self initUpperKeyBoard];
    }
}

#pragma mark - 设置字母大小写
- (void)setLowerDataSource:(NSArray *)lowerDataSource
{
    if (_lowerDataSource != lowerDataSource)
    {
        _lowerDataSource = lowerDataSource;
        NSMutableArray *upperTemp = [NSMutableArray arrayWithCapacity:_lowerDataSource.count];
        for (NSString *lower in _lowerDataSource) {
            [upperTemp addObject:[lower uppercaseString]];
        }
        _upperDataSource = [NSArray arrayWithArray:upperTemp];
    }
}

#pragma mark - 键盘处理事件
// 字母触发事件
- (void)onLettersClick:(id)sender
{
    [self onAllClick:sender clickKeyboardTag:10000];
}
// SHIFT 键
- (void)onShiftClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    [self onAllClick:sender clickKeyboardTag:PWD_CLICK_SHIFT_BTN];
}
// 删除键
- (void)onDeleteClick:(id)sender
{
    [self onAllClick:sender clickKeyboardTag:PWD_CLICK_BACK_BTN];
}
// 切换数字键
- (void)onSwitchNumbersClick:(id)sender
{
    [self onAllClick:sender clickKeyboardTag:PWD_CLICK_NUMBER_BTN];
}
// 切换字符键
- (void)onSwitchSymbolsClick:(id)sender
{
    [self onAllClick:sender clickKeyboardTag:PWD_CLICK_SYMBOL_BTN];
}
// 所有键盘事件的处理逻辑
- (void)onAllClick:(id)sender clickKeyboardTag:(int)clickKeyboardTag
{
    UIButton *button = (UIButton *)sender;
    NSString *titleStr = button.currentTitle;
  
    if (self.isLow)
    {
        self.charViewClickBlock(KEYBOARD_TYPE_SMALL_ENGLISH,clickKeyboardTag,titleStr);
    }
    else
    {
        self.charViewClickBlock(KEYBOARD_TYPE_BIG_ENGLISH,clickKeyboardTag,titleStr);
    }
    
    self.userInteractionEnabled = YES;
    [self performSelector:@selector(hiddenImageView) withObject:nil afterDelay:0.02];
}

#pragma mark - 键盘点击事件
//字母按钮点击
- (void)onLettersClickDown:(id)sender
{
    UIButton *button = (UIButton *)sender;
    self.userInteractionEnabled = NO;
    NSString *highlightImage;
    highlightImage = @"key_pressed_middle";
    
    [self showHighlightImg:highlightImage button:button isLabel:YES];
}

#pragma mark - 展示高亮图片
- (void)showHighlightImg:(NSString *)highImage  button:(UIButton *)button isLabel:(BOOL)isLabel
{
    [self hiddenImageView];

    float btnWidth = button.frame.size.width;
    float btnGetMaxX = CGRectGetMaxX(button.frame);
    float btnGetMaxY = CGRectGetMaxY(button.frame);
    
    self.imageViewButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:highImage]];
    float imageViewButtonWidthImage = self.imageViewButton.frame.size.width;
    float imageViewButtonHeightImage = self.imageViewButton.frame.size.height;
    float imageViewButtonX = btnGetMaxX - (imageViewButtonWidthImage - (imageViewButtonWidthImage - btnWidth) / 2);
    float imageViewButtonY = btnGetMaxY - imageViewButtonHeightImage;
    
    self.imageViewButton.frame = CGRectMake(imageViewButtonX, imageViewButtonY, imageViewButtonWidthImage, imageViewButtonHeightImage);
    
    
    if (isLabel) {
        //显示字母label        
        UILabel *dLabel = [[UILabel alloc] init];
        dLabel.frame = CGRectMake(0, imageViewButtonHeightImage/5, imageViewButtonWidthImage, 80);
        dLabel.textAlignment = NSTextAlignmentCenter;
        dLabel.backgroundColor = [UIColor clearColor];
        dLabel.text = button.titleLabel.text;
        dLabel.textColor = [UIColor blackColor];
        dLabel.font = [UIFont systemFontOfSize:23.0f];
        [self.imageViewButton addSubview:dLabel];
    }

    [self addSubview:self.imageViewButton];
}

#pragma mark - 隐藏图片
- (void)hiddenImageView
{
    if (_imageViewButton) {
        
        [_imageViewButton removeFromSuperview];
        _imageViewButton = nil;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    self.isLow = NO;
}

@end
