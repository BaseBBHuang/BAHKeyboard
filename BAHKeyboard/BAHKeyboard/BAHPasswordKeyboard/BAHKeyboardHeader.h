//
//  BAHKeyboardHeader.h
//  BAHKeyboard
//
//  Created by 乔贝斯 on 2017/3/31.
//  Copyright © 2017年 BAH. All rights reserved.
//

#ifndef BAHKeyboardHeader_h
#define BAHKeyboardHeader_h

/**
 * return value define <begin>
 */
#define PWD_RESULT_OK 1
#define PWD_RESULT_FAILED -1
#define PWD_RESULT_FAILED_LENTH_ERROR -2
#define PWD_CLICK_SYMBOL_BTN -4
#define PWD_CLICK_SHIFT_BTN -5
#define PWD_CLICK_NUMBER_BTN -6
#define PWD_CLICK_ENG_BTN -7
#define PWD_CLICK_BACK_BTN -8
#define PWD_CLICK_OK_BTN -9
/**
 * keyboard return value define <end>
 */

/**
 * keyboard constant value define <begin>
 */
#define PWD_NUMBER_COUNT 10
#define PWD_EVERY_ENCRYPT_LENTH 8
#define PWD_PASSKEY_LENTH 8
#define PWD_ENG_COUNT 26

#define KEYBOARD_TYPE_NUMBER 0
#define KEYBOARD_TYPE_SMALL_ENGLISH 1
#define KEYBOARD_TYPE_BIG_ENGLISH 2
#define KEYBOARD_TYPE_SYMBOLS 3


#endif /* BAHKeyboardHeader_h */
