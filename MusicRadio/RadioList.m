//
//  RadioList.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/18.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "RadioList.h"
#import "Radio.h"

@implementation RadioList
-(instancetype)initRadioList:(NSDictionary *)dic{
    if(self = [super init]){
        self.radioId = [dic objectForKey:@"id"];
        self.name = [dic objectForKey:@"name"];
        NSArray *radios = [dic objectForKey:@"radios"];
        NSMutableArray *temp = [NSMutableArray array];
        for(NSDictionary *dic in radios){
            Radio *radio = [Radio radioWithDic:dic];
            [temp addObject:radio];
        }
        self.radios = temp;
    }
    return self;
}

+(instancetype)radioList:(NSDictionary *)dic{
    return [[RadioList alloc]initRadioList:dic];
}

+(NSArray *)getRadios{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RadioList" ofType:@"plist"];
    NSArray *plistDic = [[NSArray alloc]initWithContentsOfFile:path];
    NSMutableArray *radios = [NSMutableArray array];
    for(NSDictionary *dic in plistDic){
        RadioList *radio = [RadioList radioList:dic];
        [radios addObject:radio];
    }
    return radios;
}
@end
