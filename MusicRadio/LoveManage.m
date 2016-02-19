//
//  LoveManage.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/6.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "LoveManage.h"
#import "SongManage.h"
static LoveManage *loveManger;

@interface LoveManage()
@property (nonatomic,strong) NSMutableArray *loveList;
@property (nonatomic,copy) NSString *lovePath;
@end
@implementation LoveManage
+(instancetype)share{
    static dispatch_once_t time;
    dispatch_once(&time, ^{
        loveManger = [[[self class] alloc] init];
        [loveManger readLoveList];
    });
    return loveManger;
}


-(BOOL)readLoveList{
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:self.lovePath];
    array =  array == nil ? [NSMutableArray array] : array;
    self.loveList = array;
    if(!array)
        return NO;
    return YES;
}

-(BOOL)saveLoveList{
    return [NSKeyedArchiver archiveRootObject:self.loveList toFile:self.lovePath];
}

-(BOOL)addLove:(SongManage *)song{
    int oldLen = self.loveList.count;
//    for(SongManage *class in self.loveList){
//        if(class.songName == song.songName)
//            return NO;
//    }
    BOOL result = [self isLove:song];
    if(result)
        return NO;
    [self.loveList addObject:song];
    return oldLen < self.loveList.count ? YES : NO;
}

-(BOOL)removeLoveForSong:(SongManage *)song{
    int oldLen = self.loveList.count;
    [self.loveList removeObject:song];
    return oldLen > self.loveList.count ? YES : NO;
}
-(NSArray *)getLoveList{
    return [self.loveList copy];
}


-(NSString *)lovePath{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"loveList.plist"];
    return path;
}

-(BOOL)isLove:(SongManage *)song{
    for(SongManage *class in self.loveList){
        if(class.singer == song.singer && class.songName == song.songName)
            return YES;
    }
    return NO;
}
@end
