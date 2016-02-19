//
//  LRC.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/12.
//  Copyright © 2016年 prot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRC : NSObject
/**
 *  时间，单位毫秒
 */
@property (nonatomic,assign) long time;
/**
 *  歌词
 */
@property (nonatomic,strong) NSString *value;
-(instancetype)initWithData:(NSString *)data;
+(instancetype)lrcWithData:(NSString *)data;
@end
