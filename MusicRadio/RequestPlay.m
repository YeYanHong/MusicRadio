//
//  RequestPlay.m
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
#import "RequestPlay.h"
#import "MBProgressHUD.h"
#import "KVNProgress.h"
#import "MBProgress.h"
#import "SettingManage.h"
#import "ErrorManage.h"
#import "NetworkChange.h"
typedef enum{
    getListTypeFail = 0,
    getListTypeSuccess = 1,
}getListType;

@interface RequestPlay()<ErrorManageDelegate>
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,assign) NSInteger recoverCount;
@property (nonatomic,assign) BOOL isFail;
@property (nonatomic,strong) ErrorManage *errorManager;
@property (nonatomic,assign) BOOL isDidFailGet;
@property (nonatomic,strong) Radio *currentRadio;
@property (nonatomic,assign) NSInteger playIndex;
@property (nonatomic,strong) NSData *postData;
@property (nonatomic,strong) SettingManage *settingManager;
@end

@implementation RequestPlay
-(void)getListAndPlayWithRadio:(Radio *)radio withPlayIndex:(NSInteger)index{
    if(![self isConnect])
        return;
    self.currentRadio = radio;
    self.playIndex = index;
   self.hud = [MBProgress showActivityWithTitle:@"列表获取中" withHudButton:^(UIButton *button) {
        [button setTitle:@"隐藏" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(hidHud) forControlEvents:UIControlEventTouchUpInside];
    }];
    [self getList:getListTypeSuccess];
}

-(void)getList:(getListType )type{
    [NetWorkingManage netWorkingAsynchronizationWith:[URLManage getMusicListURL] withType:NetWorkingTypePost withParam:self.postData withReceiveBlock:^(NSData *data) {
        if(data)
            [self getDataSuccess:data];
    }];
    
}

-(void)getDataSuccess:(NSData *)data{
    if(data == nil){
        [MBProgress showOlnyString:@"获取失败"];
    }
    self.isDidFailGet = YES;
    NSDictionary *musicDic = [ParserXMLJSON parseJSONFor:data];
    NSDictionary *songDic  = [musicDic objectForKey:@"data"][0];
    songDic = [songDic dicNull];
    
    [SongManage songManageWithArray:[songDic objectForKey:@"songs"] withBlock:^(NSArray *array) {
        [self.hud hideAnimated:YES];
        PlayManage *play = [PlayManage sharePlay];
        play.currentRadio = self.currentRadio;
        play.playIndex = (int)self.playIndex;
        play.music = array;
        if(array.count == 0) {
            [MBProgress showOlnyString:@"列表为空"];
        }
    }];
}

-(void)getDataFail{
    self.isDidFailGet = NO;
    if(self.settingManager.failAutoGet)
        [self.errorManager failGetListOPeration];
}

-(void)hidHud{
    [self.hud hideAnimated:YES];
}

-(void)playLoveForArray:(NSArray *)array withPlayIndex:(NSInteger)index{
    if(![self isConnect])
        return;
    PlayManage *play = [PlayManage sharePlay];
    play.currentRadio = nil;
    play.playIndex = (int)index ;
    play.music = array;
}
#pragma mark -  ErrorManage -Delegate
-(void)ErrorManageFail:(ErrorManage *)manager withCount:(NSInteger)index{
    //重新获取
    if(self.isDidFailGet == NO){
        [self getList:getListTypeSuccess];
        [MBProgress showOlnyString:[NSString stringWithFormat:@"正在尝试第%ld次获取",(long)index]];
        return;
    }
    [self.errorManager CancelOperation];
}

#pragma mark - 判断网络连接
-(BOOL)isConnect{
    NetworkChange *changer = [NetworkChange share];
    if(!changer.isConnect){
        [MBProgress showOlnyString:@"无网络连接"];
        return NO;
    }
    return YES;
}

#pragma mark - 懒加载
-(NSData *)postData{
    if(!_postData){
        NSString *postString = [NSString stringWithFormat:@"fmid0=%@&fmtype0=2&fmcount=1",self.currentRadio.fmId];
       _postData = [NSData dataWithData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return _postData;
}

-(UIView *)perantView{
    if(_perantView){
        _perantView = [[UIApplication sharedApplication].windows firstObject];
    }
    return _perantView;
}

-(SettingManage *)settingManager{
    if(_settingManager){
        _settingManager = [SettingManage share];
    }
    return _settingManager;
}

-(ErrorManage *)errorManager{
    if(_errorManager){
        _errorManager = [[ErrorManage alloc] initWithRequest:self];
        _errorManager.delegate = self;
    }
    return _errorManager;
}
@end
