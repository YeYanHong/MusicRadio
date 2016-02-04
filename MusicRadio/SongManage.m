//
//  SongManage.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/21.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "SongManage.h"
#import "URLManage.h"
#import "NetWorkingManage.h"
#import "ParserXMLJSON.h"

@interface SongManage()
@property (nonatomic,strong) NSString *songHash;

@end

@implementation SongManage
-(instancetype)initSongManage:(NSDictionary *)dic{
    if(self = [super init]){
        self.songHash = [dic objectForKey:@"hash"];
        self.songName= [dic objectForKey:@"name"];
        self.singer = [self.songName componentsSeparatedByString:@" - "][0];
        NSRange rang = [self.singer rangeOfString:@"、"];
        self.singer = rang.location > 0 ? [self.singer componentsSeparatedByString:@"、"][0] : self.singer;
        
        ParserXMLJSON *parser = [[ParserXMLJSON alloc]init];
        
        //解析下载地址
        NSURL *songDownUrl = [NSURL URLWithString:[URLManage getMusicDownAddressForHash:self.songHash]];
        NSData *songDownData = [NetWorkingManage netWorkingSynchronizationWith:songDownUrl withType:NetWorkingTypeGet withParam:nil];
        NSDictionary *songDic = [parser parseJSONFor:songDownData];
        self.songUrl = [NSURL URLWithString:[songDic objectForKey:@"url"]];
        
        //解析歌手图像
        NSString *imageUrlString = [URLManage getSingerImageForSingName:self.singer];
        imageUrlString = [imageUrlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSURL *imageUrl =[NSURL URLWithString:imageUrlString];
        NSData *imageData = [NetWorkingManage netWorkingSynchronizationWith:imageUrl withType:NetWorkingTypeGet withParam:nil];
        [parser parserXMLFor:imageData with:^(NSDictionary *dic) {
            NSRange rang = {0,8};
            self.singerImage = [NSString stringWithFormat:@"%@softhead/120/%@/%@",[dic objectForKey:@"FileDir"],[[dic objectForKey:@"FileName"] substringWithRange:rang],[dic objectForKey:@"FileName"]];
        }];
        
    }
    return self;
}

+(instancetype)songManage:(NSDictionary *)dic{
    return [[SongManage alloc]initSongManage:dic];
}

+(NSArray *)songManageWithArray:(NSArray *)array{
    NSMutableArray *songArray = [NSMutableArray array];
    for(NSDictionary *dic in array){
        SongManage *songManage = [SongManage songManage:dic];
        [songArray addObject:songManage];
    }
    return songArray;
    
}
@end
