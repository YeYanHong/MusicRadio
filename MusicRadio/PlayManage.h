//
//  PlayManage.h
//  MusicRadio
//  电台仅提供暂停，播放，下一曲功能
//
//
//  Created by 叶衍宏 on 16/1/20.
//  Copyright © 2016年 prot. All rights reserved.
//

/*
 ORGMEngineStateStopped,
 ORGMEngineStatePlaying,
 ORGMEngineStatePaused,
 ORGMEngineStateError
 
*/
typedef enum{
    PlayStatusStop = 0,
    PlayStatusPlay = 1,
    PlayStatusPaused = 2,
    PlayStatusError = 3,
}PlayStatus;

#import <Foundation/Foundation.h>
@class PlayManage,SongManage,RadioList,Radio;
@protocol PlayManageDelegate <NSObject>
@optional
/**
 *  播放一首歌调用的委托
 *
 *  @param manager 播放管理类
 *  @param song   音乐类
 */
-(void)playManage:(PlayManage *)manager withSong:(SongManage *)song withRadio:(Radio *)radio;
/**
 *  播放进度调用的委托
 *
 *  @param amountTime 总时间
 *  @param trackTime  当前时间
 */
-(void)playManage:(double)amountTime withTrack:(double)trackTime;
-(void)playmanage:(PlayManage *)manager withStatueChange:(PlayStatus )satus;
@required
@end

@interface PlayManage : NSObject
@property (nonatomic,strong) NSArray *music;
@property (nonatomic,strong) id<PlayManageDelegate> delegate;
@property (nonatomic,strong) Radio * currentRadio;
@property (nonatomic,assign) int playIndex;
@property (nonatomic,assign) PlayStatus status;
+(instancetype)sharePlay;
//播放
-(void)play;
//播放一首歌按照url
-(void)play:(SongManage *)song;
//下一曲
-(void)next;
//app进入后台继续播放需要继续的操作
-(void)enterBackground;
@end
