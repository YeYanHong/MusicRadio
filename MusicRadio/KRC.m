//
//  KRC.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/10.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "KRC.h"
#import "GTMNSData+zlib.h"
#import "LRC.h"

@implementation KRC
-(NSString *)Decode:(NSData *)data{
    NSString * EncKey = @"@Gaw^2tGQ61-ÎÒni";
    //char EncKey[] = { '@', 'G', 'a', 'w', '^', '2', 't', 'G', 'Q', '6', '1', '-', 'Î', 'Ò', 'n', 'i' };
    
    NSData * totalBytes = [[NSMutableData alloc] initWithData:data];
    //HeadBytes = [[NSMutableData alloc] initWithData:[totalBytes subdataWithRange:NSMakeRange(0, 4)]];
    EncodedBytes = [[NSMutableData alloc] initWithData:[totalBytes subdataWithRange:NSMakeRange(4, totalBytes.length - 4)]];
    
    ZipBytes = [[NSMutableData alloc] initWithCapacity:EncodedBytes.length];
    
    Byte * encodedBytes = EncodedBytes.mutableBytes;
    
    int EncodedBytesLength = EncodedBytes.length;
    
    for (int i = 0; i < EncodedBytesLength; i++)
    {
        int l = i % 16;
        char c = [EncKey characterAtIndex:l];
        
        Byte b = (Byte)((encodedBytes[i]) ^ c);
        
        [ZipBytes appendBytes:&b length:1];
        
    }
    UnzipBytes = [NSData gtm_dataByInflatingData:ZipBytes];
    
    NSString * s = [[NSString alloc] initWithData:UnzipBytes encoding:NSUTF8StringEncoding] ;
    
    return s;
    
}

//-(void)KRCToLrc:(NSString *)string withReback:(void (^)(NSString *))block{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSString *resultString = [self KRCToLrc:string];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            block(resultString);
//        });
//    });
//    
//}
- (BOOL)KRCToLrc:(NSString *)string{
    [self.lrcArray removeAllObjects];
    
    //   第一步，替换字符时间
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"<([^>]*)>" options:NSRegularExpressionCaseInsensitive error:nil];
    string = [regular stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
    
    // 第二步，去除长度
    regular = [NSRegularExpression regularExpressionWithPattern:@",[0-9]*" options:NSRegularExpressionCaseInsensitive error:nil];
    string = [regular stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:@""];
    // 第三步，组建歌词
    NSRange rang;
    NSTextCheckingResult *result;
    //获取歌手
    regular = [NSRegularExpression regularExpressionWithPattern:@"ar:[\u4e00-\u9fa5]*" options:1 error:nil];
    result = [regular firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
    rang = [result range];
    NSString *singer = [string substringWithRange:NSMakeRange(rang.location + 3,rang.length - 3)];
    //获取歌曲名
    regular = [NSRegularExpression regularExpressionWithPattern:@"ti:[\u4e00-\u9fa5]*" options:NSRegularExpressionCaseInsensitive error:nil];
    result = [regular firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
    rang = [result range];
    NSString *song = [string substringWithRange:NSMakeRange(rang.location + 3, rang.length - 3)];
    [self.lrcArray addObject:[LRC lrcWithData:[NSString stringWithFormat:@"[%d]%@ %@",0,song,singer]]];
    //处理歌词
    regular = [NSRegularExpression regularExpressionWithPattern:@"\\[[0-9]*\\]([^\\x00-\\xff]|[0-9a-zA-Z]|\\s)*" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *resultArray = [regular matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    for(result in resultArray){
        rang = [result range];
        [self.lrcArray addObject:[LRC lrcWithData:[string substringWithRange:rang]]];
    }
    NSLog(@"KRC to LRC end");
    if(self.lrcArray.count > 0)
        return YES;
    return NO;
}

-(void)KRCDataToLrcArrayFormData:(NSData *)data{
    NSString *KRCString = [self Decode:data];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if([self KRCToLrc:KRCString]){
            if([self.delegate respondsToSelector:@selector(KRC:withLRCArray:)]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate KRC:self withLRCArray:self.lrcArray];
                });
            }
        }
    });
}

#pragma mark - 懒加载
-(NSMutableArray *)lrcArray{
    if(!_lrcArray){
        _lrcArray = [[NSMutableArray alloc]init];
    }
    return _lrcArray;
}
@end
