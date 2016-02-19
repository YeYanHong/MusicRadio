//
//  RequestMusicList.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/15.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "RequestMusicList.h"
#import "Radio.h"
#import "NetWorkingManage.h"
#import "URLManage.h"
#import "NSDictionary+NSNull.h"
#import "ParserXMLJSON.h"
#import "SongManage.h"
#import "PlayManage.h"
#import "RadioList.h"

@implementation RequestMusicList
-(void)getListAndPlayWithPost:(NSString *)post withPlayIndex:(NSInteger)index{
    
    NSData *postData = [NSData dataWithData:[post dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NetWorkingManage netWorkingAsynchronizationWith:[URLManage getMusicListURL] withType:NetWorkingTypePost withParam:postData withReceiveBlock:^(NSData *data) {
        if(data){
            NSDictionary *musicDic = [ParserXMLJSON parseJSONFor:data];
            NSDictionary *songDic  = [musicDic objectForKey:@"data"][0];
            songDic = [songDic dicNull];
            
            [SongManage songManageWithArray:[songDic objectForKey:@"songs"] withBlock:^(NSArray *array) {
                PlayManage *play = [PlayManage sharePlay];
                play.playIndex = index;
                play.music = array;
            }];
        }
    }];
}

-(void)playLoveForArray:(NSArray *)array withPlayIndex:(NSInteger)index{
    PlayManage *play = [PlayManage sharePlay];
    play.playIndex = index ;
    play.music = array;
}
@end
