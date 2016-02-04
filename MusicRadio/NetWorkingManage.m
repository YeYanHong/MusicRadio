//
//  NetWorkingManage.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/19.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "NetWorkingManage.h"

@implementation NetWorkingManage
/*
 1,同步Post
 2,同步Get
 3,异步Post
 4,异步Get
*/

+(NSData *)netWorkingSynchronizationWith:(NSURL *)url withType:(NetWorkingType )type withParam:(NSData *)data{
    NSData *receiveData = nil;
    switch (type) {
        case NetWorkingTypeGet:{
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
            receiveData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        }break;
        case NetWorkingTypePost:{
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:data];
            receiveData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

        }break;
    }
    return receiveData;
}



+(NSData *)netWorkingAsynchronizationWith:(NSURL *)url withType:(NetWorkingType )type withParam:(NSDictionary *)dic withReceiveBlock:(void (^)(NSData *data))block{
    NSMutableURLRequest *mbReQuest = [[NSMutableURLRequest alloc]initWithURL:url];
    [mbReQuest setValuesForKeysWithDictionary:dic];
    [NSURLConnection sendAsynchronousRequest:mbReQuest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        block(data);
    }];
    return nil;
}
@end
