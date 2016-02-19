//
//  NetworkChange.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/16.
//  Copyright © 2016年 prot. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSNotification,Reachability;
@interface NetworkChange : NSObject
+(instancetype)share;
-(void)reachChange:(NSNotification *)note;
-(BOOL)isConnect;
-(BOOL)isWWAN;
-(BOOL)isWifi;
-(Reachability *)reachability;
@end
