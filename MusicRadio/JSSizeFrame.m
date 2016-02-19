//
//  JSSizeFrame.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/6.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "JSSizeFrame.h"

@implementation JSSizeFrame
+(CGSize)jsSizeFormString:(NSString *)string withMaxSize:(CGSize )size withFont:(UIFont *)font{
    return  [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}
@end
