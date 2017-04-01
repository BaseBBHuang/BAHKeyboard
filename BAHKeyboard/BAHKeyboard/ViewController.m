//
//  ViewController.m
//  BAHKeyboard
//
//  Created by 乔贝斯 on 2017/3/28.
//  Copyright © 2017年 BAH. All rights reserved.
//

#import "ViewController.h"
#import "BAHPassWordKeyBoard.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    BAHPassWordKeyBoard *passwordKB = [[BAHPassWordKeyBoard alloc] initKeyboardView];
    passwordKB.keyBoardLayoutStyle = KeyBoardLayoutStyleDefault;
    [passwordKB setRelationShipTextFiled:self.textField];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
    
}




@end
