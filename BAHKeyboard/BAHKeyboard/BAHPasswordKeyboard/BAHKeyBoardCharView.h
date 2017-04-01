//
//  BAHKeyBoardCharView.h
//
//  Created by 乔贝斯 on 2017/3/28.
//  Copyright © 2017年 BAH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CharViewClickBlock)(int state,int key,NSString *inputText);

/*
* 为了给键盘添加取消处理，增加的代理方法
*/
@protocol BAHKeyBoardCharViewDelegate <NSObject>

@optional
- (void)KeyBoardCharViewButtonCancel:(id)sender;

@end

@interface BAHKeyBoardCharView : UIView
/** 小写 */
@property (nonatomic, strong) NSArray *lowerDataSource;
/** 大写 */
@property (nonatomic, strong) NSArray *upperDataSource;
@property (nonatomic, copy) CharViewClickBlock charViewClickBlock;
@property (nonatomic, weak)id<BAHKeyBoardCharViewDelegate> delegate;

- (void)switchKeyBoard;
- (id)initWithFrame:(CGRect)frame;
- (void)initLowerKeyBoard;
- (void)initUpperKeyBoard;


@end
