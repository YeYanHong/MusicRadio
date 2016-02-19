//
//  ActiveityView.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/17.
//  Copyright © 2016年 prot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ActiveityView : NSObject
-(instancetype)initWithParentView:(UIView *)view;
-(void)start;
-(void)stop;
@end
