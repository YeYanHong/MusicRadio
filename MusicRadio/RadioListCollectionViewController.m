//
//  RadioListCollectionViewController.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/16.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "RadioListCollectionViewController.h"
#import "Radio.h"
#import "RadioList.h"
#import "RadioCollectionViewCell.h"
#import "RadioCollectionReusableView.h"

@interface RadioListCollectionViewController ()
@property (nonatomic,strong) NSArray *radios;
@end

@implementation RadioListCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const reuseIdentifierForHeadView = @"RadioReusableView";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[RadioCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView registerClass:[RadioCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierForHeadView];
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = [UIColor whiteColor];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger count = self.radios.count ;
    return count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    RadioList *radioList = self.radios[section];
    NSInteger count = radioList.radios.count;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RadioCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    RadioList *list = self.radios[indexPath.section];
    cell.radioModel = list.radios[indexPath.row];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    RadioCollectionReusableView *headView =(RadioCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifierForHeadView forIndexPath:indexPath];
    if([kind isKindOfClass:[UICollectionElementKindSectionHeader class]]){
        RadioList *list = self.radios[indexPath.section];
        headView.headDescLabel.text = list.name;
    }
    return headView;
}


#pragma mark - <UICollectionViewFlowLayou>
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70, 90);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize currentSize = [UIScreen mainScreen].bounds.size;
    CGSize size = {currentSize.width,45};
    return size;
}

#pragma mark <UICollectionViewDelegate>
-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor grayColor]];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
}


#pragma mark - 懒加载
-(NSArray *)radios{
    if(_radios == nil){
        _radios = [RadioList getRadios];
    }
    return _radios;
}

#pragma mark - 系统设置
-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
