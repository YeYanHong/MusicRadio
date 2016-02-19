//
//  RequestMusicList.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/15.
//  Copyright © 2016年 prot. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Radio;

@interface RequestMusicList : NSObject
-(void)getListAndPlayWithPost:(NSString *)post withPlayIndex:(NSInteger)index;
-(void)playLoveForArray:(NSArray *)array withPlayIndex:(NSInteger)index;
@end
