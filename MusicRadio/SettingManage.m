//
//  SettingManage.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/14.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "SettingManage.h"
#import "Radio.h"
@interface SettingManage ()
@property (nonatomic,copy) NSString *path;
@property (nonatomic,strong) NSMutableDictionary *settingDic;
@end
static SettingManage *setting;
@implementation SettingManage

-(instancetype)init{
    if(self = [super init]){
        self.radioIndex = [NSNumber numberWithInt:0];
        self.fmIndex = [NSNumber numberWithInt:0];
        self.isAutoPlay = YES;
        self.failAutoGet = YES;
        self.failCount = [NSNumber numberWithInt:1];
        self.useNoWifiRemind = YES;
        Radio *radio = [[Radio alloc]init];
        radio.fmId = [NSNumber numberWithInt:73];
        radio.fmName = @"KTV必点曲";
        radio.imgUrl = @"20130128102454463911.png";
        self.radio = radio;
    }
    return self;
}

+(instancetype)share{
    static dispatch_once_t time;
    dispatch_once(&time, ^{
        setting = [NSKeyedUnarchiver unarchiveObjectWithFile:[SettingManage path]];
        if(setting == nil)
            setting = [[SettingManage alloc]init];
    });
    return setting;
}

//-(BOOL)read{
//    self.settingDic = [[NSMutableDictionary alloc] initWithContentsOfFile:self.path];
//    if(self.settingDic == nil)
//    {
//        [self defaultSetting];
//        self.settingDic = [[NSMutableDictionary alloc]init];
//        [self.settingDic setValue:self forKey:@"setting"];
//    }
//    self = 
//    return YES;
//}

-(BOOL)save{
//    [self.settingDic removeAllObjects];
//    [self.settingDic setValue:self forKey:@"setting"];
//
//    NSMutableDictionary *radioDic = [NSMutableDictionary dictionary];
//    [radioDic setObject:self.radio.fmId forKey:@"fmId"];
//    [radioDic setObject:self.radio.fmName forKey:@"fmName"];
//    [radioDic setObject:self.radio.imgUrl forKey:@"imgUrl"];
//    
//    [self.settingDic setObject:radioDic forKey:@"radio"];
//    [self.settingDic setValue:[NSNumber numberWithBool:self.isAutoPlay] forKey:@"isAutoPlay"];
//    [self.settingDic setObject:[NSNumber numberWithBool:self.failAutoGet] forKey:@"failAutoGet"];
//    [self.settingDic setObject:[NSNumber numberWithBool:self.useNoWifiRemind] forKey:@"useNoWifiRemind"];
//    [self.settingDic setObject:self.fmIndex forKey:@"fmIndex"];
//    [self.settingDic setObject:self.radioIndex forKey:@"radioIndex"];
//    BOOL result = [self.settingDic writeToFile:self.path atomically:NO];
    BOOL result = [NSKeyedArchiver archiveRootObject:self toFile:[SettingManage path]];
    NSLog(@"setting save result =  %@",result == YES ? @"success" : @"fail" );
    return result;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.isAutoPlay = [aDecoder decodeBoolForKey:@"isAutoPlay"];
        self.failAutoGet = [aDecoder decodeBoolForKey:@"failAutoGet"];
        self.useNoWifiRemind = [aDecoder decodeBoolForKey:@"useNoWifiRemind"];
        self.radio = [aDecoder decodeObjectForKey:@"radio"];
        self.radioIndex = [aDecoder decodeObjectForKey:@"radioIndex"];
        self.fmIndex = [aDecoder decodeObjectForKey:@"fmIndex"];
        self.failCount = [aDecoder decodeObjectForKey:@"failCount"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeBool:self.isAutoPlay forKey:@"isAutoPlay"];
    [aCoder encodeBool:self.failAutoGet forKey:@"failAutoGet"];
    [aCoder encodeBool:self.useNoWifiRemind forKey:@"useNoWifiRemind"];
    [aCoder encodeObject:self.radio forKey:@"radio"];
    [aCoder encodeObject:self.radioIndex forKey:@"radioIndex"];
    [aCoder encodeObject:self.fmIndex forKey:@"fmIndex"];
    [aCoder encodeObject:self.failCount forKey:@"failCount"];
}

#pragma mark - 懒加载
+(NSString *)path{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"UserSetting.plist"];
    return path;
}

@end
