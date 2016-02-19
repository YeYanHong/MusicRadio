//
//  KRC.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/10.
//  Copyright © 2016年 prot. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KRC;
@protocol KRCDelegate <NSObject>
@optional
//KRC转LRC成功后的代理
-(void)KRC:(KRC *)krc withLRCArray:(NSArray *)array;
@required

@end


@interface KRC : NSObject{
    //FileStream fs;
    
    //头部4字节
    NSMutableData * HeadBytes;
    
    //异或加密内容
    NSMutableData * EncodedBytes;
    
    //解异或加密后ZIP数据
    NSMutableData * ZipBytes;
    
    //UNZIP后数据
    NSData * UnzipBytes;
}
/**
 *  存储歌词的数组
 */
@property (nonatomic,strong) NSMutableArray *lrcArray;
@property (nonatomic,strong) id<KRCDelegate> delegate;
//- (NSString *) Decode: (NSData *)data;
//- (void) KRCToLrc:(NSString *)string withReback:(void(^)(NSString *string))block;
-(void)KRCDataToLrcArrayFormData:(NSData *)data;

@end
