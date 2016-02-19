//
//  SettingManage.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/14.
//  Copyright © 2016年 prot. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Radio;

@interface SettingManage : NSObject<NSCoding>
/**
 *  是否自动播放
 */
@property (nonatomic,assign) BOOL isAutoPlay;
/**
 *  自动播放的列表
 */
@property (nonatomic,strong) Radio *radio;
/**
 *  获取列表失败时候是否自动重新获取
 */
@property (nonatomic,assign) BOOL failAutoGet;
/**
 *  使用流量播放时候是否提示
 */
@property (nonatomic,assign) BOOL useNoWifiRemind;
/**
 *  记录pick fm 选择的序号
 */
@property (nonatomic,assign) NSNumber *fmIndex;
/**
 *  记录pick radio 记录的序号
 */
@property (nonatomic,assign) NSNumber *radioIndex;
/**
 *  重获次数
 */
@property (nonatomic,assign) NSNumber *failCount;
+(instancetype)share;
-(BOOL)save;
@end
