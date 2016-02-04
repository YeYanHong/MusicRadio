//
//  RadioCollectionReusableView.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/19.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "RadioCollectionReusableView.h"

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
@end
