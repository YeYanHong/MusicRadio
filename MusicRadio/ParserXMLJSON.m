//
//  ParserXMLJSON.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/21.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "ParserXMLJSON.h"

@interface ParserXMLJSON()<NSXMLParserDelegate>
@property (nonatomic,strong) NSMutableDictionary *xmlDic;
@property (nonatomic,copy) void (^parserBlock)(NSDictionary *dic);
@property (nonatomic,copy) NSString *tempCharacter;
@property (nonatomic,copy) NSString *tempElementName;
@end

@implementation ParserXMLJSON


-(void)parserXMLFor:(NSData *)data with:(void(^)(NSDictionary *dic))block{
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
    parser.delegate = self;
    self.parserBlock = block;
    self.tempCharacter = [NSMutableString string];
    [parser parse];
}

-(NSDictionary *)parseJSONFor:(NSData *)data{
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

#pragma mark - NSXMLParserDelegate
//开始解析文档
-(void)parserDidStartDocument:(NSXMLParser *)parser{
    self.xmlDic = [[NSMutableDictionary alloc]init];
}
//发现节点
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    self.tempElementName = elementName;
}
//发现内容
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    self.tempCharacter = string;
}
//结束节点
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    [self.xmlDic setObject:self.tempCharacter forKey:self.tempElementName];
}
//结束解析文档
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    self.parserBlock(self.xmlDic);
}
@end
