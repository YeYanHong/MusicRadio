//
//  JSSizeFrame.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/6.
//  Copyright © 2016年 prot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JSSizeFrame : NSObject
+(CGSize)jsSizeFormString:(NSString *)string withMaxSize:(CGSize )size withFont:(UIFont *)font;
@end
