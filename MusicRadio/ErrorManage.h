//
//  ErrorManage.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/16.
//  Copyright © 2016年 prot. All rights reserved.
//
typedef enum{
    ErrorTypeNullList = 10,
    ErrorTypeFailGet  = 1,
}ErrorType;

#import <Foundation/Foundation.h>
@class Radio,RequestPlay,ErrorManage;

@protocol ErrorManageDelegate <NSObject>
@optional
-(void)ErrorManageFail:(ErrorManage *)manager withCount:(NSInteger )index;
@required

@end

@interface ErrorManage : NSObject
@property (nonatomic,strong) id<ErrorManageDelegate> delegate;
/**
 *  处理NSdictionary value NSNull 时候的错误
 *
 *  @param dic dic
 *
 *  @return 处理后的dictionary
 */
-(NSDictionary *)isNullList:(NSDictionary *)dic;
/**
 *  获取音乐列表失败后的处理
 */
-(void)failGetListOPeration;
-(instancetype)initWithRequest:(RequestPlay *)request;
-(void)CancelOperation;

@end
