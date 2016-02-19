//
//  NetworkChange.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/16.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "NetworkChange.h"
#import "Reachability.h"
#import "SettingManage.h"
#import "MBProgress.h"

@interface NetworkChange()
@property (nonatomic,strong) Reachability *reach;
@end
static NetworkChange *network;
@implementation NetworkChange
+(instancetype)share{
    static dispatch_once_t time;
    dispatch_once(&time, ^{
        network = [[NetworkChange alloc]init];
    });
    return network;
}

-(void)reachChange:(NSNotification *)note{
    //注释原因是因为网络变化时候产生不可预知的错误，1，多次调用。2，最后一次调用才是正确
    Reachability *obj = [note object];
    NetworkStatus status = [obj currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            NSLog(@"无网络连接");
            [MBProgress showOlnyString:@"网络已断开"];
            break;
        case ReachableViaWiFi:
            NSLog(@"Wifi连接");
            break;
        case ReachableViaWWAN:{
            NSLog(@"2G/3G连接");
            BOOL isRemind = [SettingManage share].useNoWifiRemind;
            if(isRemind)
                [MBProgress showOlnyString:@"当前网络为2G/3G,谨慎使用"];
        }break;
    }
//    if([self isWWAN]){
//        NSLog(@"2G/3G");
//        BOOL isRemind = [SettingManage share].useNoWifiRemind;
//        if(isRemind)
//            [MBProgress showOlnyString:@"当前网络为2G/3G,谨慎使用"];
//    }
//    else if([self isConnect]){
//        NSLog(@"断开");
//        [MBProgress showOlnyString:@"网络已断开"];
//    }
//    else if([self isWifi]){
//        NSLog(@"wifi");
//    }
}

-(BOOL)isConnect{
    return [self.reach currentReachabilityStatus] == NotReachable ? NO : YES;
}

-(BOOL)isWifi{
    return [self.reach currentReachabilityStatus] == ReachableViaWiFi ? YES : NO;
}

-(BOOL)isWWAN{
    return [self.reach currentReachabilityStatus] == ReachableViaWWAN ? YES : NO;

}

-(Reachability *)reachability{
    return self.reach;
}
#pragma mark 懒加载
-(Reachability *)reach{
    if(!_reach){
        _reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    }
    return _reach;
}
@end
