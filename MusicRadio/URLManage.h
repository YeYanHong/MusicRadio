//
//  URLManage.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/20.
//  Copyright © 2016年 prot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLManage : NSObject
+(NSURL *)getMusicListURL;
+(NSString *)getMusicDownAddressForHash:(NSString *)hash;
+(NSURL *)getSingerImageForSingName:(NSString *)name;
+(NSURL *)getLrcForSongName:(NSString *)name withTimeLength:(NSString *)time withHash:(NSString *)hash;
@end
