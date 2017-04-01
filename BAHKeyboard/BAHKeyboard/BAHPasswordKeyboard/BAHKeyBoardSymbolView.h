//
//  BAHKeyBoardSymbolView.h
//
//  Created by 乔贝斯 on 2017/3/28.
//  Copyright © 2017年 BAH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SymbolViewClickBlock)(int state,int key,NSString *inputText);

@interface BAHKeyBoardSymbolView : UIView

/** 符号 */
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, copy) SymbolViewClickBlock symbolViewClickBlock;

- (id)initWithFrame:(CGRect)frame;
- (void)initKeyBoard;

@end
