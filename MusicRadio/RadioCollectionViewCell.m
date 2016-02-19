//
//  RadioCollectionViewCell.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/18.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "RadioCollectionViewCell.h"
#import "Radio.h"

@interface RadioCollectionViewCell()
@end

@implementation RadioCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        NSArray *arrayOfViews = [[NSBundle mainBundle]loadNibNamed:@"RadioCollectionViewCell" owner:self options:nil];
        if(arrayOfViews.count < 1)
            return nil;
        if(![[arrayOfViews firstObject] isKindOfClass:[UICollectionViewCell class]])
            return nil;
        self = [arrayOfViews firstObject];
    }
    return self;
}


-(void)setRadioModel:(Radio *)radioModel{
    _radioModel = radioModel;
    //赋值
    self.imageView.image = [UIImage imageNamed:_radioModel.imgUrl];
    self.descLabel.text = _radioModel.fmName;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 25;
    self.imageView.layer.borderWidth = 0;
}
@end
