//
//  PlayViewController.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/16.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "PlayViewController.h"
#import "MFSideMenu.h"
#import "NetWorkingManage.h"
#import "URLManage.h"
#import "SongManage.h"
#import "PlayManage.h"
#import "RadioList.h"
#import "LoveListTableViewController.h"
#import "LoveManage.h"
#import "JSSizeFrame.h"
#import "LRCView.h"
#import "KRC.h"
#import "SettingTableViewController.h"
#import "SettingManage.h"
#import "RequestPlay.h"
#import "Radio.h"
#import "ActiveityView.h"

@interface PlayViewController ()<PlayManageDelegate,KRCDelegate>
@property (weak, nonatomic) IBOutlet UIButton *moreRadioBtn;
@property (weak, nonatomic) IBOutlet UILabel *currentRadio;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UIImageView *songImage;
@property (weak, nonatomic) IBOutlet UIProgressView *songProgress;
@property (weak, nonatomic) IBOutlet UIButton *songLove;
@property (weak, nonatomic) IBOutlet UIButton *play;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIButton *loveList;
@property (weak, nonatomic) IBOutlet UIButton *setting;
@property (nonatomic,strong) ActiveityView *activetyView;
@property (weak, nonatomic) IBOutlet UIView *LRCParentView;

@property (nonatomic,strong) LRCView *LRCView;
@property (nonatomic,strong) KRC *krc;

@property (nonatomic,strong) SongManage *currentSongManage;
@property (nonatomic,strong) SettingManage *settingManager;
@property (weak, nonatomic) IBOutlet UIView *activityParentView;
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PlayManage *play = [PlayManage sharePlay];
    play.delegate = self;
    
    self.settingManager = [SettingManage share];
    if(self.settingManager.isAutoPlay)
        [self autoPlay];
    [self viewDefaultSetting];
}


#pragma mark - 系统设置
-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (IBAction)moreRadioClick:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
}


#pragma mark -Other
-(void)setCurrentSongManage:(SongManage *)currentSongManage{
    _currentSongManage = currentSongManage;
    
    //显示当前播放的歌曲名字
    self.songName.text = @"";
    self.songName.text = _currentSongManage.songName;
    CGSize maxSize = CGSizeMake(self.view.frame.size.width, 30);
    CGSize fitSize = [JSSizeFrame jsSizeFormString:self.songName.text withMaxSize:maxSize withFont:[self.songName font]];
    CGFloat songNameX =( self.view.frame.size.width - fitSize.width ) / 2.0;
    CGRect songNameRect = CGRectMake(songNameX, self.songName.frame.origin.y, fitSize.width, self.songName.frame.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        self.songName.frame = songNameRect;
    }];
    
    //加载头像
    [NetWorkingManage netWorkingAsynchronizationWith:currentSongManage.singerImage withType:NetWorkingTypeGet withParam:nil withReceiveBlock:^(NSData *data) {
        self.songImage.image = [UIImage imageWithData:data];
    }];
    
    //加载歌词
    [self.LRCView recover];
    [NetWorkingManage netWorkingAsynchronizationWith:_currentSongManage.songLrc withType:NetWorkingTypeGet withParam:nil withReceiveBlock:^(NSData *data) {
        if(data)
            [self.krc KRCDataToLrcArrayFormData:data];
    }];
}

#pragma mark - PlayManagerDelegate
-(void)playManage:(PlayManage *)manager withSong:(SongManage *)song withRadio:(Radio *)radio{
    self.currentSongManage = song;
    [self.songProgress setProgress:0 animated:YES];
    [self setPlayButtonImage];
    [self setLoveButtonImage];
    self.songImage.image = [UIImage imageNamed:@"songImage"];
    if(radio){
        self.currentRadio.text =[NSString stringWithFormat:@"正在收听:%@",    radio.fmName];
        self.currentRadio.hidden = NO;
        [self.activetyView start];
    }
    else{
        self.currentRadio.text = @"";
        self.currentRadio.hidden = YES;
        [self.activetyView stop];
    }
        
}

-(void)playManage:(double)amountTime withTrack:(double)trackTime{
    float progress = amountTime / trackTime;
    [self.songProgress setProgress:progress animated:YES];
    [self.LRCView setCurrentTime:amountTime];
}

-(void)playmanage:(PlayManage *)manager withStatueChange:(PlayStatus)satus{
    [self setPlayButtonImage];
}

#pragma mark - KRCDelegate
-(void)KRC:(KRC *)krc withLRCArray:(NSArray *)array{
    self.LRCView.lrcArray = self.krc.lrcArray;
}


#pragma mark - click
- (IBAction)play:(UIButton *)sender {
    [[PlayManage sharePlay] play];
}
- (IBAction)next:(UIButton *)sender {
    [[PlayManage sharePlay] next];
}
-(IBAction)loveListClick:(id)sender{
    LoveListTableViewController *loveListTvc = [[LoveListTableViewController alloc] initWithStyle: UITableViewStylePlain];
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:loveListTvc];
    [self presentViewController:navigation animated:YES completion:nil];
}
-(IBAction)settingClick:(id)sender{
    SettingTableViewController *settingVC = [SettingTableViewController viewFormStory];
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:settingVC];
    [self presentViewController:navigation animated:YES completion:nil];
}

-(IBAction)addLoveClick:(id)sender{
    if(!self.currentSongManage)
        return ;
    LoveManage *manager = [LoveManage share];
    if([manager isLove:self.currentSongManage])
        [manager removeLoveForSong:self.currentSongManage];
    else
        [manager addLove:self.currentSongManage];
    [self setLoveButtonImage];
}

#pragma mark - 懒加载
-(LRCView *)LRCView{
    if(!_LRCView){
        _LRCView = [[LRCView alloc] initWithParentView:self.LRCParentView];
    }
    return _LRCView;
}

-(KRC *)krc{
    if(!_krc){
        _krc = [[KRC alloc]init];
        _krc.delegate = self;
    }
    return _krc;
}

#pragma mark - 用户设置
//自动播放
-(void)autoPlay{
    RequestPlay *request = [[RequestPlay alloc]init];
    request.perantView = self.view;
    Radio *radio = self.settingManager.radio;
    [request getListAndPlayWithRadio:radio withPlayIndex:0];
    
}

#pragma mark - UI设置
-(void)viewDefaultSetting{
    [self setPlayButtonImage];
    self.view.backgroundColor = [UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1.0];
    
    //添加动画控件
    ActiveityView *view = [[ActiveityView alloc] initWithParentView:self.activityParentView];
    self.activetyView = view;
}

-(void)setLoveButtonImage{
    LoveManage *manager = [LoveManage share];
    UIImage *image = ([manager isLove:self.currentSongManage] == YES ? [UIImage imageNamed:@"chat_collection_icon_yet"] : [UIImage imageNamed:@"chat_collection_icon"]) ;
    [self.songLove setImage:image forState:UIControlStateNormal];
}
-(void)setPlayButtonImage{
    PlayManage *play = [PlayManage sharePlay];
    PlayStatus status = [play status];
    UIImage *image = (status == PlayStatusPaused || status == PlayStatusStop) ? [UIImage imageNamed:@"status_bar_play"] : [UIImage imageNamed:@"status_bar_stop"];
    [self.play setImage:image forState:UIControlStateNormal];
}
@end
