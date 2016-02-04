//
//  RadioList.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/18.
//  Copyright © 2016年 prot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadioList : NSObject
@property (nonatomic,strong) NSNumber *radioId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSArray *radios;
-(instancetype)initRadioList:(NSDictionary *)dic;
+(instancetype)radioList:(NSDictionary *)dic;
+(NSArray *)getRadios;
@end
