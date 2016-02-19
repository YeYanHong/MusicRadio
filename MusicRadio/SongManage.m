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
#import "KRC.h"

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
        
        NSDictionary *songDic = [ParserXMLJSON parseJSONFor:songDownData];
        self.songUrl = [NSURL URLWithString:[songDic objectForKey:@"url"]];
        
        
        //解析歌手图像
        NSURL *imageUrl = [URLManage getSingerImageForSingName:self.singer];
        NSData *imageData = [NetWorkingManage netWorkingSynchronizationWith:imageUrl withType:NetWorkingTypeGet withParam:nil];
        
        [parser parserXMLFor:imageData with:^(NSDictionary *dic) {
            NSRange rang = {0,8};
            NSString *imageString = [NSString stringWithFormat:@"%@softhead/200/%@/%@",[dic objectForKey:@"FileDir"],[[dic objectForKey:@"FileName"] substringWithRange:rang],[dic objectForKey:@"FileName"]];
            self.singerImage = [NSURL URLWithString:imageString];
        }];
        
        self.songLrc = [URLManage getLrcForSongName:self.songName withTimeLength:[songDic objectForKey:@"timeLength"] withHash:self.songHash];
    }
    return self;
}

+(instancetype)songManage:(NSDictionary *)dic{
    return [[SongManage alloc]initSongManage:dic];
}

+(void)songManageWithArray:(NSArray *)array withBlock:(void(^)(NSArray *array))block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *songArray = [NSMutableArray array];
        for(NSDictionary *dic in array){
            SongManage *songManage = [SongManage songManage:dic];
            [songArray addObject:songManage];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            block(songArray);
        });
    });
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self.songName = [aDecoder decodeObjectForKey:@"songName"];
    self.singer = [aDecoder decodeObjectForKey:@"singer"];
    self.singerImage = [aDecoder decodeObjectForKey:@"singerImage"];
    self.songLrc = [aDecoder decodeObjectForKey:@"songLrc"];
    self.songUrl = [aDecoder decodeObjectForKey:@"songUrl"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.songName forKey:@"songName"];
    [aCoder encodeObject:self.singer forKey:@"singer"];
    [aCoder encodeObject:self.singerImage forKey:@"singerImage"];
    [aCoder encodeObject:self.songLrc forKey:@"songLrc"];
    [aCoder encodeObject:self.songUrl forKey:@"songUrl"];
    
}
@end
