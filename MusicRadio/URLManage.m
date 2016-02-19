//
//  URLManage.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/20.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "URLManage.h"
#include <math.h>

@implementation URLManage

+(NSURL *)getMusicListURL{
    NSString *url = @"http://www.kugou.com/fm/app/i/?cmd=1&uid=44333827&key=45bddce826dbd9555a2ddfa3a0d9a8ec";
    return  [NSURL URLWithString:url];
}

+(NSString *)getMusicDownAddressForHash:(NSString *)hash{
    NSString *url = @"http://m.kugou.com/app/i/getSongInfo.php?cmd=playInfo&hash=";
    url = [url stringByAppendingString:hash];
    return url;
}

+(NSURL *)getSingerImageForSingName:(NSString *)name{
    NSString *url = [NSString stringWithFormat:@"http://singerimage.kugou.com/topimage.aspx?singername=%@&size=260&type=softhead",name];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:url];
}

+(NSURL *)getLrcForSongName:(NSString *)name withTimeLength:(NSString *)time withHash:(NSString *)hash{
    NSString *urlString = [NSString stringWithFormat:@"http://mobilecdn.kugou.com/new/app/i/krc.php?keyword=%@&timelength=%d&type=1&cmd=200&hash=%@",name,[time intValue] * 1000,hash];
   NSURL *url =  [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}
@end
