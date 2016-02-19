//
//  LoveManage.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/6.
//  Copyright © 2016年 prot. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SongManage;
@interface LoveManage : NSObject
+(instancetype)share;
-(BOOL)isLove:(SongManage *)song;
-(BOOL)readLoveList;
-(BOOL)saveLoveList;
-(BOOL)addLove:(SongManage *)song;
-(BOOL)removeLoveForSong:(SongManage *)song;
-(NSArray *)getLoveList;
@end
