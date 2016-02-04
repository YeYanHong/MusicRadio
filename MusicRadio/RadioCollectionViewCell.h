//
//  RadioCollectionViewCell.h
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/18.
//  Copyright © 2016年 prot. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Radio;
@interface RadioCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (nonatomic,strong) Radio *radioModel;
@end
