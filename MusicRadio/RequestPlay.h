//
//  RequestPlay.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/15.
//  Copyright © 2016年 prot. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Radio;

@interface RequestPlay : NSObject
@property (nonatomic,strong) UIView *perantView;
/**
 *  申请获取列表并且播放
 *
 *  @param radio 电台
 *  @param index 获取成功后播放的序号
 */
-(void)getListAndPlayWithRadio:(Radio *)radio withPlayIndex:(NSInteger)index;
/**
 *  申请播放最喜爱列表的音乐
 *
 *  @param array 最爱列表
 *  @param index 获取成功后播放的序号
 */
-(void)playLoveForArray:(NSArray *)array withPlayIndex:(NSInteger)index;

@end
