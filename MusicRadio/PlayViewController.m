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
@interface PlayViewController ()
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

@property (nonatomic,strong) SongManage *currentSongManage;
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
//    [paramDic setObject:[NSNumber numberWithInt:2] forKey:@"fmid0"];
//    [paramDic setObject:[NSNumber numberWithInt:73] forKey:@"fmtype0"];
//    [paramDic setObject:[NSNumber numberWithInt:1] forKey:@"fmcount"];
    NSString *postString = [NSString stringWithFormat:@"fmid0=%d&fmtype0=%d&fmcount=%d",73,2,1];
    NSData *postData = [[NSData alloc]initWithData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [[NSURL alloc]initWithString:[URLManage getMusicListURL]];
    NSData *data = [NetWorkingManage netWorkingSynchronizationWith:url withType:NetWorkingTypePost withParam:postData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *songArray = [[dic objectForKey:@"data"][0] objectForKey:@"songs"];
    NSArray *songManageArray = [SongManage songManageWithArray:songArray];
    self.currentSongManage = songManageArray[0];
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
    self.songName.text = currentSongManage.songName;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *imageUrl = [NSURL URLWithString:currentSongManage.singerImage];
        /*
         NSDataReadingMappedIfSafe =   1UL << 0,	// Hint to map the file in if possible and safe
         NSDataReadingUncached = 1UL << 1,	// Hint to get the file not to be cached in the kernel
         NSDataReadingMappedAlways NS_ENUM_AVAILABLE(10_7, 5_0) = 1UL << 3,	// Hint to map the file in if possible. This takes precedence over NSDataReadingMappedIfSafe if both are given.
         
         // Options with old names for NSData reading methods. Please stop using these old names.
         NSDataReadingMapped = NSDataReadingMappedIfSafe,	// Deprecated name for NSDataReadingMappedIfSafe
         NSMappedRead = NSDataReadingMapped,			// Deprecated name for NSDataReadingMapped
         NSUncachedRead = NSDataReadingUncached
         
         */
        NSData *imageData =[NSData dataWithContentsOfURL:imageUrl options: NSUncachedRead error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.songImage.image = [UIImage imageWithData:imageData];
        });
    });
    
    PlayManage *play = [PlayManage sharePlay];
    [play playUrl:currentSongManage.songUrl];
}

@end
