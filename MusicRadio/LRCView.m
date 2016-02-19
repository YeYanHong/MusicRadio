//
//  LRCView.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/12.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "LRCView.h"
#import "LRC.h"
#import "JSSizeFrame.h"
@interface LRCView()
@property (nonatomic,strong) UIView *parentView;
@property (nonatomic,assign) NSInteger index;
@end
@implementation LRCView

-(instancetype)initWithParentView:(UIView *)view{
    if(self == [super init]){
        //一、定义
        self.parentView = view;
        CGFloat width = view.frame.size.width;
        CGFloat hieght = view.frame.size.height;
        CGFloat oneHieght = hieght * 0.3333;
        
        //定义第一个lab
        self.beforeLab = [[UILabel alloc]init];
        self.beforeLab.textColor = [UIColor colorWithRed:168.f/255.f green:168.f/255.f blue:168.f/255.f alpha:1.0];
        self.beforeLab.textAlignment = NSTextAlignmentCenter;
        self.beforeLab.font = [UIFont systemFontOfSize:12];
        CGFloat beforeLabY = oneHieght * 0;
        CGFloat beforeLabX = 0;
        CGFloat beforeLabWidth = width;
        CGFloat beforeLabHieght = oneHieght;
        CGRect beforeLabRect = CGRectMake(beforeLabX, beforeLabY, beforeLabWidth, beforeLabHieght);
        self.beforeLab.frame = beforeLabRect;
        
        //定义第二个lab
        self.currentLab = [[UILabel alloc]init];
        [self.currentLab setTextColor:[UIColor colorWithRed:58.f / 255.f green:181.f/255.f blue:231.f/255.f alpha:1]];
        self.currentLab.textAlignment = NSTextAlignmentCenter;
        self.currentLab.font = [UIFont systemFontOfSize:13];
        CGFloat currentLabY = oneHieght * 1;
        CGFloat currentLabX = 0;
        CGFloat currentLabWidth = width;
        CGFloat currentLaHieght = oneHieght;
        CGRect currentRect = CGRectMake(currentLabX, currentLabY, currentLabWidth, currentLaHieght);
        self.currentLab.frame = currentRect;
        
        //定义第二个lab
        self.afterLab = [[UILabel alloc]init];
        self.afterLab.textColor =  [UIColor colorWithRed:168.f/255.f green:168.f/255.f blue:168.f/255.f alpha:1.0];
        self.afterLab.textAlignment = NSTextAlignmentCenter;
        self.afterLab.font = [UIFont systemFontOfSize:12];
        CGFloat afterLabY = oneHieght * 2 ;
        CGFloat afterLabX = 0;
        CGFloat afterLabWidth = width;
        CGFloat afterLabHieght = oneHieght;
        CGRect afterLabRect = CGRectMake(afterLabX, afterLabY, afterLabWidth, afterLabHieght);
        self.afterLab.frame = afterLabRect;
        
        [self addSubview:self.beforeLab];
        [self addSubview:self.currentLab];
        [self addSubview:self.afterLab];
        [self.parentView addSubview:self];

        CGFloat x = 0 ;
        CGFloat y = 0;
        CGRect rect = CGRectMake(x, y,view.frame.size.width, view.frame.size.height);
        self.frame = rect;
    }
    return self;
}

-(void)setCurrentTime:(double)time{
    for(int i = self.index ; i < self.lrcArray.count ; i++){
//        NSArray *timeStringArray = [[NSString stringWithFormat:@"%f",time] componentsSeparatedByString:@"."];
//        int minute = [timeStringArray[0] intValue];
//        int second = [timeStringArray[1] intValue];
        long resultTime = time * 1000;
        
        LRC *beforeLRC = self.lrcArray[i > 0 ? i - 1 : i];
        LRC *currentLRC = self.lrcArray[i];
        LRC *nextentLRC = self.lrcArray[i < self.lrcArray.count - 1 ? i + 1 : i];
//        
        if((resultTime >= beforeLRC.time && resultTime <= nextentLRC.time) || currentLRC.time == nextentLRC.time){
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{

                self.beforeLab.text = i == 0 ? @"" : beforeLRC.value;
                self.currentLab.text = currentLRC.value;
                self.afterLab.text = i >= self.lrcArray.count - 1 ? @"" : nextentLRC.value;
                
                
                CGSize currentScreenSize = [UIScreen mainScreen].bounds.size;
                
                //第一个lab适应大小
                CGSize beforeSize = [JSSizeFrame jsSizeFormString:self.beforeLab.text withMaxSize:currentScreenSize withFont:[UIFont systemFontOfSize:12]];
                CGRect newBeforeRect = CGRectMake((currentScreenSize.width - beforeSize.width) / 2.0, self.beforeLab.frame.origin.y, beforeSize.width, self.beforeLab.frame.size.height);
                self.beforeLab.frame = newBeforeRect;
                
                //第二个lab适应大小
                CGSize currentSize = [JSSizeFrame jsSizeFormString:self.currentLab.text withMaxSize:currentScreenSize withFont:[UIFont systemFontOfSize:13]];
                CGRect newCurrentRect = CGRectMake((currentScreenSize.width - currentSize.width) / 2.0, self.currentLab.frame.origin.y, currentSize.width, self.currentLab.frame.size.height);
                self.currentLab.frame = newCurrentRect;
                
                //第二个lab适应大小
                CGSize aferSize = [JSSizeFrame jsSizeFormString:self.afterLab.text withMaxSize:currentScreenSize withFont:[UIFont systemFontOfSize:12]];
                CGRect newAfterRect = CGRectMake((currentScreenSize.width - aferSize.width) / 2.0, self.afterLab.frame.origin.y,aferSize.width, self.afterLab.frame.size.height);
                self.afterLab.frame = newAfterRect;
            } completion:nil];
            self.index = i;
            break;
        }
    }
    
}

-(void)recover{
    self.index = 0 ;
    self.lrcArray = nil;
    self.beforeLab.text = @"";
    self.currentLab.text = @"歌词加载中......";
    self.afterLab.text = @"";
}

@end
