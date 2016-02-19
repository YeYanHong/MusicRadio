//
//  Radio.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/18.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "Radio.h"

@implementation Radio
-(instancetype)initRadioWithDic:(NSDictionary *)dic{
    if(self = [super init]){
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+(instancetype)radioWithDic:(NSDictionary *)dic{
    return [[Radio alloc]initRadioWithDic:dic];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self.fmId = [aDecoder decodeObjectForKey:@"fmId"];
    self.imgUrl = [aDecoder decodeObjectForKey:@"fmUrl"];
    self.fmName = [aDecoder decodeObjectForKey:@"fmName"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.fmId forKey:@"fmId"];
    [aCoder encodeObject:self.fmName forKey:@"fmName"];
    [aCoder encodeObject:self.imgUrl forKey:@"imgUrl"];
}
@end
