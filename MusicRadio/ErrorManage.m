//
//  ErrorManage.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/16.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "ErrorManage.h"
#import "NSDictionary+NSNull.h"
#import "SettingManage.h"
#import "RequestPlay.h"
#import "MBProgress.h"

@interface ErrorManage()
@property (nonatomic,strong) RequestPlay *requst;
@property (nonatomic,assign) NSInteger failCount;
@property (nonatomic,strong) NSOperationQueue *queue;
@end
@implementation ErrorManage

-(instancetype)initWithRequest:(RequestPlay *)request{
    if(self = [super init]){
        self.requst = request;
    }
    return self;
}

-(NSDictionary *)isNullList:(NSDictionary *)dic{
    return [dic dicNull];
}

-(void)failGetListOPeration{
    self.queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *oldOperation = nil;
    for(int i = 0 ; i < self.failCount ; i ++){
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            if([self.delegate respondsToSelector:@selector(ErrorManageFail:withCount:)])
                [self.delegate ErrorManageFail:self withCount:i];
        }];
        if(oldOperation)
            [oldOperation addDependency:operation];
        oldOperation = operation;
        [self.queue addOperation:operation];
    }
    
}

-(void)CancelOperation{
    [self.queue cancelAllOperations];
}

#pragma mark - 懒加载
-(NSInteger)failCount{
    SettingManage *setting = [SettingManage share];
    _failCount = [setting.failCount intValue];
    return _failCount;
}

@end
