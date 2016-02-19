//
//  NSDictionary+NSNull.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/14.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "NSDictionary+NSNull.h"

@implementation NSDictionary (NSNull)
-(NSDictionary *)dicNull{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *keyArray = [self allKeys];
    for(int i = 0 ; i < keyArray.count ; i ++){
        id obj = [self objectForKey:keyArray[i]];
        if([obj isKindOfClass:[NSNull class]])
            obj = [NSArray array];
        [dic setObject:obj forKey:keyArray[i]];
    }
    return dic;
}

@end
