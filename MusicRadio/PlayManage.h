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
    playStatueStop = 0,
    playStatuePlay = 1,
    playStatuePaused = 2,
    playStatueError = 3,
}playStatue;

#import <Foundation/Foundation.h>
@class PlayManage,SongManage;
@protocol PlayManageDelegate <NSObject>
@optional
/**
 *  播放一首歌调用的委托
 *
 *  @param manager 播放管理类
 *  @param song   音乐类
 */
-(void)playManage:(PlayManage *)manager withSong:(SongManage *)song;
/**
 *  播放进度调用的委托
 *
 *  @param amountTime 总时间
 *  @param trackTime  当前时间
 */
-(void)playManage:(double)amountTime withTrack:(double)trackTime;
@required
@end

@interface PlayManage : NSObject
@property (nonatomic,strong) NSArray *music;
@property (nonatomic,strong) id<PlayManageDelegate> delegate;
+(instancetype)sharePlay; 
-(void)playUrl:(NSURL *)url;
//播放
-(void)play;
//下一曲
-(void)next;
@end
