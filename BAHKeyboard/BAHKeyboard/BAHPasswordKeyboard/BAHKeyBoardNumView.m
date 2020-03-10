//
//  BAHKeyBoardNumView.m
//
//  Created by 乔贝斯 on 2017/3/28.
//  Copyright © 2017年 BAH. All rights reserved.
//

#import "BAHKeyBoardNumView.h"
#import "BAHPassWordKeyBoard.h"


@interface BAHKeyBoardNumView ()

@property (strong, nonatomic) NSArray *numCollections;
@property (strong, nonatomic) UIButton *okButton;
@property (strong, nonatomic) UIButton *switchButtonABC;
@property (strong, nonatomic) UIButton *delButton;
@property (strong, nonatomic) UIImageView *imageViewButton;

//初始化键盘数字
- (void)initNum;
@end

@implementation BAHKeyBoardNumView
{
    float numKeyWidth;
    float numKeyHeight;
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
    //布局按钮
    [self setupNumCollections];
    //切换按钮
    [self setupSwitchABCButton];
    //删除按钮
    [self setupDeleteButton];
}

#pragma mark - 数字按钮布局
- (void)setupNumCollections
{
    int row = 4;
    int column = 3;
    
    CGFloat buttonSafeAreaWidth = self.frame.size.width;
    CGFloat buttonSafeAreaHeight = self.frame.size.height - kBottomSafeArea;
    
    numKeyWidth = buttonSafeAreaWidth/column;
    numKeyHeight = buttonSafeAreaHeight/row;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //布局前面两行
    for (NSInteger i=0; i<2; i++)
    {
        for (NSInteger j=0; j<3; j++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(numKeyWidth*j, numKeyHeight*i, numKeyWidth, numKeyHeight);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
            [self addSubview:btn];
            [array addObject:btn];
        }
    }
    //布局第三行
    for (NSInteger j=0; j<3; j++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(numKeyWidth*j, 2*numKeyHeight, numKeyWidth, numKeyHeight);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        [self addSubview:btn];
        [array addObject:btn];
    }
    
    //最后一行按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(numKeyWidth, 3*numKeyHeight, numKeyWidth, numKeyHeight);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [self addSubview:btn];
    [array addObject:btn];
    
    //numCollecions保存数字按钮
    self.numCollections = [[NSArray alloc] initWithArray:array];
    
    //给数字按钮设置背景图片
    UIImage *img = [UIImage imageNamed:@"key_num_column_1"];
    UIImage *selImg = [UIImage imageNamed:@"key_num_column_1_pressed"];
    for (int i = 0; i < self.numCollections.count; i++)
    {
        UIButton *button = [self.numCollections objectAtIndex:i];
        [button setBackgroundImage:img forState:UIControlStateNormal];
        [button setBackgroundImage:selImg forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:25.0f];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(onNumbersClick:) forControlEvents:UIControlEventTouchUpInside];
    }

}

- (void)setupSwitchABCButton
{
    self.switchButtonABC = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchButtonABC.frame = CGRectMake(0, 3*numKeyHeight, numKeyWidth, numKeyHeight);
    [self.switchButtonABC setBackgroundImage:[UIImage imageNamed:@"key_num_column_1_last_row"] forState:UIControlStateNormal];
    [self.switchButtonABC setBackgroundImage:[UIImage imageNamed:@"key_num_column_1_last_row_pressed"] forState:UIControlStateHighlighted];
    [self.switchButtonABC setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.switchButtonABC setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.switchButtonABC.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.switchButtonABC setTitle:@"ABC" forState:UIControlStateNormal];
    [self.switchButtonABC setTitle:@"ABC" forState:UIControlStateHighlighted];
    [self addSubview:self.switchButtonABC];
    [self.switchButtonABC addTarget:self action:@selector(onSwitchABCClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupDeleteButton
{
    self.delButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.delButton.frame = CGRectMake(2*numKeyWidth, 3*numKeyHeight, numKeyWidth, numKeyHeight);
    [self.delButton setBackgroundImage:[UIImage imageNamed:@"key_num_column_3_last_row"] forState:UIControlStateNormal];
    [self.delButton setBackgroundImage:[UIImage imageNamed:@"key_num_column_3_pressed"] forState:UIControlStateHighlighted];
    [self.delButton setImage:[UIImage imageNamed:@"key_icon_del"] forState:UIControlStateNormal];
    [self.delButton setImage:[UIImage imageNamed:@"key_icon_del"] forState:UIControlStateHighlighted];
    [self addSubview:self.delButton];
    [self.delButton addTarget:self action:@selector(onDeleteNumbersClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 初始化数字数据
- (void)initNum
{
    for (int i = 0; i < self.numCollections.count; i++)
    {
        UIButton *button = [self.numCollections objectAtIndex:i];
        [button setTitle:[self.dataSource objectAtIndex:i] forState:UIControlStateNormal];
    }
}

#pragma mark - 键盘点击事件
- (void)onNumbersClick:(id)sender
{
    [self onNumbersAllClick:sender clickKeyboardTag:1000];
}

- (void)onSwitchABCClick:(id)sender
{
    [self onNumbersAllClick:sender clickKeyboardTag:PWD_CLICK_ENG_BTN];
}

- (void)onDeleteNumbersClick:(id)sender
{
    [self onNumbersAllClick:sender clickKeyboardTag:PWD_CLICK_BACK_BTN];
}

- (void)onNumbersAllClick:(id)sender clickKeyboardTag:(int)clickKeyboardTag
{
    UIButton *button = (UIButton *)sender;
    NSString *titleStr = button.currentTitle;
    self.numViewClickBlock(clickKeyboardTag,titleStr);
}



@end
