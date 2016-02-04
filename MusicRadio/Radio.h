//
//  Radio.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/18.
//  Copyright © 2016年 prot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Radio : NSObject
@property(nonatomic,strong) NSNumber *fmId;
@property(nonatomic,strong) NSString *fmName;
@property(nonatomic,strong) NSString *imgUrl;
-(instancetype)initRadioWithDic:(NSDictionary *)dic;
+(instancetype)radioWithDic:(NSDictionary *)dic;
@end
