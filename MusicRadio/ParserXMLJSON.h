//
//  ParserXMLJSON.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/21.
//  Copyright © 2016年 prot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GZIP.h"

@interface ParserXMLJSON : NSObject
-(void)parserXMLFor:(NSData *)data with:(void(^)(NSDictionary *dic))block;
+(NSDictionary *)parseJSONFor:(NSData *)data;
@end
