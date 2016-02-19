//
//  MBProgress.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/15.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "MBProgress.h"
#import "MBProgressHUD.h"

@implementation MBProgress
+(MBProgressHUD *)showActivityWithTitle:(NSString *)title withHudButton:(void (^)(UIButton *))block{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows firstObject] animated:YES];
    hud.label.text = title;
    block(hud.button);
    return hud;
}

+(void)showOlnyString:(NSString *)string{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows firstObject] animated:YES];
    hud.mode =  MBProgressHUDModeText;
    hud.label.text = string;
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    [hud hideAnimated:YES afterDelay:2.0];
}
@end
