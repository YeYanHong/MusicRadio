//
//  URLManage.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/20.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "URLManage.h"

@implementation URLManage

+(NSString *)getMusicListURL{
    NSString *url = @"http://www.kugou.com/fm/app/i/?cmd=1&uid=44333827&key=45bddce826dbd9555a2ddfa3a0d9a8ec";
    return url;
}

+(NSString *)getMusicDownAddressForHash:(NSString *)hash{
    NSString *url = @"http://m.kugou.com/app/i/getSongInfo.php?cmd=playInfo&hash=";
    url = [url stringByAppendingString:hash];
    return url;
}

+(NSString *)getSingerImageForSingName:(NSString *)name{
    NSString *url = @"http://singerimage.kugou.com/topimage.aspx?size=90&singername=";
    url = [url stringByAppendingFormat:@"%@&type=softhead",name];
    return url;
}
@end
