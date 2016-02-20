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
#import "STKAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#include <math.h>

@interface PlayManage ()
@property (nonatomic,strong) STKAudioPlayer *audioPlayer;
/**
 *  负责管理播放的进度，下一曲等等作用的队列
 */
@property (nonatomic,strong) NSOperationQueue *playManagerQueue;
///**
// *  负责管理播放进度，下一曲等等
// */
//@property (nonatomic,strong) NSBlockOperation *playManagerOperation;
@end

static PlayManage *playManage;
@implementation PlayManage

-(instancetype)init{
    if(self = [super init]){
        self.audioPlayer = [[STKAudioPlayer alloc]init];
        [self.audioPlayer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:NULL];
    }
    return self;
}

+(instancetype)sharePlay{
    static dispatch_once_t oneTokem;
    dispatch_once(&oneTokem, ^{
        playManage = [[[self class] alloc] init];
    });
    return playManage;
}


/*
 STKAudioPlayerStateReady,
 STKAudioPlayerStateRunning = 1,
 STKAudioPlayerStatePlaying = (1 << 1) | STKAudioPlayerStateRunning,
 STKAudioPlayerStateBuffering = (1 << 2) | STKAudioPlayerStateRunning,
 STKAudioPlayerStatePaused = (1 << 3) | STKAudioPlayerStateRunning,
 STKAudioPlayerStateStopped = (1 << 4),
 STKAudioPlayerStateError = (1 << 5),
 STKAudioPlayerStateDisposed = (1 << 6)
 */
-(void)play{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (self.audioPlayer.state) {
            case STKAudioPlayerStateStopped:{}break;
            case STKAudioPlayerStatePlaying:{
                [self.audioPlayer pause];
            }break;
            case STKAudioPlayerStatePaused:{
                [self.audioPlayer resume];
            }break;
            case STKAudioPlayerStateError:{}break;
            default:{};
        }
    });
}
-(void)play:(SongManage *)song{
    [self.audioPlayer playURL:song.songUrl];
    if([self.delegate respondsToSelector:@selector(playManage:withSong:withRadio:)])
        [self.delegate playManage:self withSong:song withRadio:self.currentRadio];
}

-(void)next{
    if(self.music.count == 0)
        return;
    self.playIndex = ( self.playIndex + 1 ) % self.music.count;
    [self playForIndex];
}

-(void)playForIndex{
    if(self.music.count == 0)
        return ;
    SongManage *song = self.music[self.playIndex];
    if([self.delegate respondsToSelector:@selector(playManage:withSong:withRadio:)]){
        [self.delegate playManage:self withSong:song withRadio:self.currentRadio];
    }
//    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioPlayer playURL:song.songUrl];
//    });
}


#pragma mark - 属性相关函数
-(void)setMusic:(NSArray *)music{
    _music = music;
    [self playForIndex];
    [self.playManagerQueue setSuspended:NO];
    
    //开始管理播放
}

-(void)enterBackground{
    [self.audioPlayer resume];
}

#pragma mark - 懒加载
-(NSOperationQueue *)playManagerQueue{
    if(!_playManagerQueue){
        _playManagerQueue = [[NSOperationQueue alloc]init];
        _playManagerQueue.name = @"playManagerQueue";
        [_playManagerQueue addOperationWithBlock:^{
            while (true) {
//                if(self.audioPlayer.state == STKAudioPlayerStateStopped || self.audioPlayer.state == STKAudioPlayerStatePaused)
//                    continue;
                //可以调用各种的委托
                double amoutTime = self.audioPlayer.progress;//当前时间
                double trackTime = self.audioPlayer.duration;//总共时间
                if(fabs(trackTime - amoutTime) < 0.000001 && amoutTime != 0.000000)
                    [self next];
                if(self.audioPlayer.state == STKAudioPlayerStateStopped || self.audioPlayer.state == STKAudioPlayerStatePaused)
                    continue;
                NSLog(@"amout = %f --- track = %f",amoutTime,trackTime);
                if([self.delegate respondsToSelector:@selector(playManage:withTrack:)]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate playManage:amoutTime withTrack:trackTime];
                    });
                }
                
                [NSThread sleepForTimeInterval:1];
            }
        }];
    }
    return _playManagerQueue;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"state"]){
        switch (self.audioPlayer.state) {
            case STKAudioPlayerStateStopped:{
                self.status = PlayStatusStop;
            }break;
            case STKAudioPlayerStatePlaying:{
                self.status = PlayStatusPlay;
            }break;
            case STKAudioPlayerStatePaused:{
                self.status = PlayStatusPaused;
            }break;
            case STKAudioPlayerStateError:{
                self.status = PlayStatusError;
            }break;
            default:{};
        }
        if([self.delegate respondsToSelector:@selector(playmanage:withStatueChange:)])
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate playmanage:self withStatueChange:self.status];
            });
    }
}
@end
