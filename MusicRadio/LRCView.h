//
//  LRCView.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/12.
//  Copyright © 2016年 prot. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LRCView : UIView
@property (nonatomic,strong) UILabel *beforeLab;
@property (nonatomic,strong) UILabel *currentLab;
@property (nonatomic,strong) UILabel *afterLab;
/**
 *  歌词
 */
@property (nonatomic,strong) NSArray *lrcArray;
-(instancetype)initWithParentView:(UIView *)view;
/**
 *  赋值当前时间，LRCView根据当前时间展示不同的内容
 */
-(void)setCurrentTime:(double )time;
-(void)recover;
@end
