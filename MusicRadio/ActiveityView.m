//
//  ActiveityView.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/17.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "ActiveityView.h"
#import "MMMaterialDesignSpinner.h"

@interface ActiveityView ()
@property (nonatomic,strong) MMMaterialDesignSpinner *animateView;
@property (nonatomic,strong) UIView *parentView;
@end

@implementation ActiveityView
-(instancetype)initWithParentView:(UIView *)view{
    if(self = [super init]){
        self.parentView = view;

        self.animateView = [[MMMaterialDesignSpinner alloc]initWithFrame:CGRectZero];
        self.animateView.bounds = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        self.animateView.center = CGPointMake(CGRectGetMidY(view.bounds), CGRectGetMidY(view.bounds));
        self.animateView.lineWidth = 1.5f;
        self.animateView.duration = 3.0;
        self.animateView.tintColor = [UIColor colorWithRed:255.f / 255.f green:255.f/255.f blue:255.f/255.f alpha:1];
        self.animateView.hidesWhenStopped = YES;
        self.animateView.hidden = YES;
        [view addSubview:self.animateView];
    }
    return self;
}

-(void)start{
    [self.animateView startAnimating];
}

-(void)stop{
    [self.animateView stopAnimating];
}
@end
