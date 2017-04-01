//
//  BAHKeyBoardOnlyNumView.h
//
//  Created by 乔贝斯 on 2017/3/28.
//  Copyright © 2017年 BAH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NumViewClickBlock)(int key,NSString *title);

@interface BAHKeyBoardNumView : UIView

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) NumViewClickBlock numViewClickBlock;

//初始化键盘数字
- (void)initNum;

@end
