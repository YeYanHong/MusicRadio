//
//  RadioCollectionReusableView.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/19.
//  Copyright © 2016年 prot. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RadioCollectionReusableView,RadioList;
@protocol RadioCollectionHeadViewDelegate <NSObject>
@optional
-(void)RadioCollectionHeadView:(RadioCollectionReusableView *)view headButtonClickWithInex:(NSInteger )index;
@required

@end
@interface RadioCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *headDescButton;
@property (nonatomic,strong) id<RadioCollectionHeadViewDelegate> delegate;
@property (nonatomic,strong) RadioList *model;

+(instancetype)radioCollectionReuseableViewWith:(UICollectionView *)collectView withKid:(NSString *)kind withReuseId:(NSString *)reuseId forIndexPath:(NSIndexPath *)indexPath;

@end
