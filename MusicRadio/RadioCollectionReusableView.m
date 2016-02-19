//
//  RadioCollectionReusableView.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/19.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "RadioCollectionReusableView.h"
#import "RadioList.h"

@implementation RadioCollectionReusableView

+(instancetype)radioCollectionReuseableViewWith:(UICollectionView *)collectView withKid:(NSString *)kind withReuseId:(NSString *)reuseId forIndexPath:(NSIndexPath *)indexPath{
    RadioCollectionReusableView *view = [collectView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseId forIndexPath:indexPath];
    return view;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        NSArray *arrayOfView = [[NSBundle mainBundle] loadNibNamed:@"RadioCollectionReusableView" owner:self options:nil];
        if(arrayOfView.count < 1)
            return nil;
        if(![[arrayOfView firstObject] isKindOfClass:[UICollectionReusableView class]])
            return nil;
        self = [arrayOfView firstObject];
    }
    return self;
}

-(IBAction)moreRadio:(UIButton *)button{
    self.model.isExpend = !self.model.isExpend;
    [self setHeadButtonImage];
    [self.delegate RadioCollectionHeadView:self headButtonClickWithInex:self.tag];
}

-(void)setModel:(RadioList *)model{
    _model = model;
    [self.headDescButton setTitle:model.name forState:UIControlStateNormal];
    [self setHeadButtonImage];
}

-(void)setHeadButtonImage{
    self.headDescButton.layer.borderWidth = 2;
    self.headDescButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.headDescButton.layer setMasksToBounds:YES];
    [self.headDescButton.layer setCornerRadius:15];
    if(self.model.isExpend)
        self.headDescButton.imageView.transform = CGAffineTransformMakeRotation(0);
    else
        self.headDescButton.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
}
@end
