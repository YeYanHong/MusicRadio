//
//  MBProgress.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/15.
//  Copyright © 2016年 prot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MBProgressHUD;

@interface MBProgress : NSObject
+(MBProgressHUD *)showActivityWithTitle:(NSString *)title withHudButton:(void (^)(UIButton *button))block;
+(void)showOlnyString:(NSString *)string;
@end
