//
//  LRC.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/12.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "LRC.h"

@implementation LRC
-(instancetype)initWithData:(NSString *)data{
    if(self == [super init]){
        //去除\r\n
        data = [data stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        //分割
        NSArray *dataArray = [data componentsSeparatedByString:@"]"];
        //分别赋值
        NSString *oneData = dataArray[0];
        NSString *twoData = dataArray[1];
        self.time = [[oneData substringWithRange:NSMakeRange(1, oneData.length - 1)] intValue];
        self.value = twoData;
    }
    return self;
}

+(instancetype)lrcWithData:(NSString *)data{
    return [[LRC alloc]initWithData:data];
}

@end
