//
//  NetWorkingManage.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/19.
//  Copyright © 2016年 prot. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    NetWorkingTypeGet = 0,
    NetWorkingTypePost = 1,
}NetWorkingType;

@interface NetWorkingManage : NSObject
+(NSData *)netWorkingSynchronizationWith:(NSURL *)url withType:(NetWorkingType )type withParam:(NSData *)data;
+(NSData *)netWorkingAsynchronizationWith:(NSURL *)url withType:(NetWorkingType )type withParam:(NSDictionary *)dic withReceiveBlock:(void (^)(NSData *data))block;
@end
