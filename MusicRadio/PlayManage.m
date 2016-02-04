//
//  PlayManage.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/20.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "PlayManage.h"
#import "ORGMEngine.h"
#import "SongManage.h"

@interface PlayManage ()
@property (nonatomic,strong) ORGMEngine *orgmengine;
@property (nonatomic,assign) int playIndex;
/**
 *  负责管理播放的进度，下一曲等等作用
 */
@property (nonatomic,strong) NSThread *playManagerThread;
@end

static PlayManage *playManage;
@implementation PlayManage

-(instancetype)init{
    if(self = [super init]){
        self.orgmengine = [[ORGMEngine alloc]init];
    }
    return self;
}
//单例模式
+(instancetype)sharePlay{
    static dispatch_once_t oneTokem;
    dispatch_once(&oneTokem, ^{
        playManage = [[[self class] alloc] init];
    });
    return playManage;
}

-(void)playUrl:(NSURL *)url{
    [self.orgmengine playUrl:url];
}

/*
 ORGMEngineStateStopped,
 ORGMEngineStatePlaying,
 ORGMEngineStatePaused,
 ORGMEngineStateError
 */
-(void)play{
    switch (self.orgmengine.currentState) {
        case ORGMEngineStateStopped:{}break;
        case ORGMEngineStatePlaying:{
            [self.playManagerThread cancel];
            [self.orgmengine pause];
        }break;
        case ORGMEngineStatePaused:{
            [self.orgmengine resume];
        }break;
        case ORGMEngineStateError:{}break;
        default:{};
    }
    
}

-(void)next{
    self.playIndex += 1;
    [self playForIndex];
    
}

-(void)playForIndex{
    SongManage *song = self.music[self.playIndex];
    [self.orgmengine playUrl:song.songUrl];
    if([self.delegate respondsToSelector:@selector(playManage:withSong:)]){
        [self.delegate playManage:self withSong:song];
    }
}


#pragma mark - 属性相关函数
-(void)setMusic:(NSArray *)music{
    _music = music;
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(progressManager) object:nil];
    self.playManagerThread = thread;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_global_queue(0, 0), ^{
        //设置音乐列表3秒自动播放列表的音乐
        [self playForIndex];
        [self.playManagerThread start];
    });
}


#pragma mark - progress manager
-(void)progressManager{
    while (true) {
        //可以调用各种的委托
        double amoutTime = self.orgmengine.amountPlayed;//总共时间
        double trackTime = self.orgmengine.trackTime;//当前时间
        if([self.delegate respondsToSelector:@selector(playManage:withTrack:)]){
            [self.delegate playManage:amoutTime withTrack:trackTime];
        }
        if(trackTime >= amoutTime){
            //2秒后自动播放下一曲
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_global_queue(0, 0), ^{
                [self next];
            });
        }
    
        [NSThread sleepForTimeInterval:1];
    }
}

@end
