//
//  URLManage.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/20.
//  Copyright © 2016年 prot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLManage : NSObject
+(NSString *)getMusicListURL;
+(NSString *)getMusicDownAddressForHash:(NSString *)hash;
+(NSString *)getSingerImageForSingName:(NSString *)name;
@end
