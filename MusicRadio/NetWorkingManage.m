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



+(void)netWorkingAsynchronizationWith:(NSURL *)url withType:(NetWorkingType )type withParam:(NSData *)data withReceiveBlock:(void (^)(NSData *data))block{
    switch (type) {
        case NetWorkingTypeGet:{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:0 timeoutInterval:20];
                [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(data);
                    });
                }];
            });
        }break;
        case NetWorkingTypePost:{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSMutableURLRequest *mbRequest = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:0 timeoutInterval:20];
                [mbRequest setHTTPMethod:@"POST"];
                [mbRequest setHTTPBody:data];
                [mbRequest setTimeoutInterval:20];
                [NSURLConnection sendAsynchronousRequest:mbRequest queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(data);
                    });
                }];
            });
        }break;
    }
}
@end
