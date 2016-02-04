//
//  SongManage.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/21.
//  Copyright © 2016年 prot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongManage : NSObject
@property (nonatomic,strong) NSString *songName;
@property (nonatomic,strong) NSString *singer;
@property (nonatomic,strong) NSString *singerImage;
@property (nonatomic,strong) NSURL *songLrc;
@property (nonatomic,strong) NSURL *songUrl;

-(instancetype)initSongManage:(NSDictionary *)dic;
+(instancetype)songManage:(NSDictionary *)dic;
+(NSArray *)songManageWithArray:(NSArray *)array;
@end
