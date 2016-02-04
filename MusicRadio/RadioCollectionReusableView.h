//
//  RadioCollectionReusableView.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/19.
//  Copyright © 2016年 prot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *headDescLabel;

+(instancetype)radioCollectionReuseableViewWith:(UICollectionView *)collectView withKid:(NSString *)kind withReuseId:(NSString *)reuseId forIndexPath:(NSIndexPath *)indexPath;

@end
