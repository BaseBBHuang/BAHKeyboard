//
//  BAHKeyBoardCharView.m
//
//  Created by 乔贝斯 on 2017/3/28.
//  Copyright © 2017年 BAH. All rights reserved.
//

#import "BAHKeyBoardSymbolView.h"
#import "BAHPassWordKeyBoard.h"


@interface BAHKeyBoardSymbolView ()

@property (strong, nonatomic)NSArray *charCollections;

/** 删除 */
@property (strong, nonatomic) UIButton *delButton;
/** 切换数字 */
@property (strong, nonatomic) UIButton *switch123Button;
/** 切换字母 */
@property (strong, nonatomic) UIButton *switchABCButton;
/** 高亮按钮 */
@property (strong, nonatomic) UIImageView *imageViewButton;


@end

@implementation BAHKeyBoardSymbolView
{
    float space_x;//按钮竖间距
    float space_y;//按钮行间距
    float btn_height;//按钮的高度
    float btn_width;//按钮的宽度

}
- (id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        // 布局
        [self setupLayoutButton];
    }
    return self;
}

#pragma mark - 布局
- (void)setupLayoutButton
{
    //按钮布局
    [self setupSymbolsButton];
    //删除按钮
    [self setupSymbolsDeleteButton];
    //切换按钮
    [self setupSymbolsSwitchButton];
}

#pragma mark - 布局字母按钮
- (void)setupSymbolsButton
{
    space_x = 2;
    space_y = 7;

    CGFloat buttonSafeAreaWidth = self.frame.size.width;
    CGFloat buttonSafeAreaHeight = self.frame.size.height - kBottomSafeArea;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    btn_width = (buttonSafeAreaWidth - space_x*11)/10;
    btn_height = (buttonSafeAreaHeight - space_y*5)/4;
    for (NSInteger i=0; i<2; i++)
    {
        for (NSInteger j=0; j<10; j++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(space_x+(space_x+btn_width)*j, i*btn_height+(i+1)*space_y, btn_width, btn_height);
            [self addSubview:btn];
            [array addObject:btn];
        }
    }

    for (NSInteger i=0; i<1; i++)
    {
        for (NSInteger j=0; j<8; j++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(space_x+(space_x+btn_width)*j, (i+2)*btn_height+3*space_y, btn_width, btn_height);
            [self addSubview:btn];
            [array addObject:btn];
        }
    }
    
    float lastLinePadding = (self.frame.size.width - 7*btn_width - 6*space_x)/2;
    for (NSInteger i=0; i<7; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(lastLinePadding+(space_x+btn_width)*i, 3*btn_height+4*space_y, btn_width, btn_height);
        [self addSubview:btn];
        [array addObject:btn];
    }
    
    self.charCollections = [[NSArray alloc] initWithArray:array];
    
    //为字符按钮设置图片和事件
    UIImage *img = [UIImage imageNamed:@"key_normal"];
    
    for (int i = 0; i < self.charCollections.count; i++)
    {
        UIButton *button = [self.charCollections objectAtIndex:i];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [button setBackgroundImage:img forState:UIControlStateNormal];
        [button setTitle:[self.dataSource objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onSymbolsClick:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(onSymbolsClick:) forControlEvents:UIControlEventTouchUpOutside];
        [button addTarget:self action:@selector(onSymbolsClickDown:) forControlEvents:UIControlEventTouchDown];
        [button setExclusiveTouch:YES];
    }
}

- (void)setupSymbolsDeleteButton
{
    self.delButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.delButton.frame = CGRectMake(9*space_x+8*btn_width, 2*btn_height+3*space_y, 2*btn_width, btn_height);
    [self.delButton setImage:[UIImage imageNamed:@"key_icon_del"] forState:UIControlStateNormal];
    [self.delButton setBackgroundImage:[UIImage imageNamed:@"key_mood_normal"] forState:UIControlStateNormal];
    [self.delButton addTarget:self action:@selector(onSymbolsDeleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.delButton];
}

- (void)setupSymbolsSwitchButton
{
    float switchButtonWidth = (self.frame.size.width-7*btn_width-10*space_x)/2;
    self.switch123Button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switch123Button.frame = CGRectMake(space_x, 3*btn_height+4*space_y, switchButtonWidth, btn_height);
    [self.switch123Button setBackgroundImage:[UIImage imageNamed:@"key_mood_normal"] forState:UIControlStateNormal];
    [self.switch123Button setTitle:@"123" forState:UIControlStateNormal];
    [self.switch123Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.switch123Button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.switch123Button.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.switch123Button addTarget:self action:@selector(onSwitch123Click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.switch123Button];

    self.switchABCButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchABCButton.frame = CGRectMake(self.frame.size.width-2*space_x-switchButtonWidth, 3*btn_height+4*space_y, switchButtonWidth, btn_height);
    [self.switchABCButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.switchABCButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.switchABCButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.switchABCButton setTitle:@"ABC" forState:UIControlStateNormal];
    [self.switchABCButton setBackgroundImage:[UIImage imageNamed:@"key_mood_normal"] forState:UIControlStateNormal];
    [self.switchABCButton addTarget:self action:@selector(onSwitchABCClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.switchABCButton];

}

#pragma mark - 初始化小写键盘数据
- (void)initKeyBoard
{
    for (int i = 0; i < self.charCollections.count; i++)
    {
        UIButton *button = [self.charCollections objectAtIndex:i];
        [button setTitle:[self.dataSource objectAtIndex:i] forState:UIControlStateNormal];
    }
}

#pragma mark - 键盘点击事件
//按钮点击
- (void)onSymbolsClickDown:(id)sender
{
    UIButton *button = (UIButton *)sender;
    self.userInteractionEnabled = NO;
    NSString *highlightImage;
    highlightImage = @"key_pressed_middle";
    
    
    [self showHighlightImg:highlightImage button:button isLabel:YES];
    
}

- (void)onSymbolsClick:(id)sender
{
    [self onAllSymbolsClick:sender clickKeyboardTag:1000];
}

- (void)onSymbolsDeleteClick:(id)sender
{
    [self onAllSymbolsClick:sender clickKeyboardTag:PWD_CLICK_BACK_BTN];
}

- (void)onSwitch123Click:(id)sender
{
    [self onAllSymbolsClick:sender clickKeyboardTag:PWD_CLICK_NUMBER_BTN];
}

- (void)onSwitchABCClick:(id)sender
{
    [self onAllSymbolsClick:sender clickKeyboardTag:PWD_CLICK_ENG_BTN];
}

- (void)onAllSymbolsClick:(id)sender clickKeyboardTag:(int)clickKeyboardTag
{
    UIButton *button = (UIButton *)sender;
    NSString *titleStr = button.currentTitle;
    self.userInteractionEnabled = YES;
    self.symbolViewClickBlock(KEYBOARD_TYPE_SYMBOLS,clickKeyboardTag,titleStr);
    [self performSelector:@selector(hiddenImageView) withObject:nil afterDelay:0.02];
}

- (void)hiddenImageView
{
    if (_imageViewButton) {
        [_imageViewButton removeFromSuperview];
        _imageViewButton = nil;
    }
    
}

//符号按钮点击
- (void)onClickDown:(id)sender
{
    UIButton *button = (UIButton *)sender;
    self.userInteractionEnabled = NO;
    [self showHighlightImg:@"key_highlight" button:button isLabel:YES];
    
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


@end
