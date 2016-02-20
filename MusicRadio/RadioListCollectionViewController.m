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
#import "NetWorkingManage.h"
#import "SongManage.h"
#import "URLManage.h"
#import "ParserXMLJSON.h"
#import "PlayManage.h"
#import "NSDictionary+NSNull.h"
#import "RequestPlay.h"

@interface RadioListCollectionViewController ()<RadioCollectionHeadViewDelegate>
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
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"radiolist_default_background"]];
    imageView.frame = self.collectionView.frame;
    self.collectionView.backgroundView = imageView;
    
    self.view.backgroundColor = [UIColor colorWithRed:202.f/255.f green:202.f/255.f blue:202.f/255.f alpha:1];
    
//    [imageView sendSubviewToBack:self.view];
//    [self.collectionView bringSubviewToFront:self.view];
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    CGRect newRect = CGRectMake(0,self.collectionView.frame.origin.y + 44, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    self.collectionView.frame = newRect;
    self.collectionView.backgroundColor = [UIColor colorWithRed:238.f/255.f green:243.f/255.f blue:246.f/255.f alpha:1];
    [self.collectionView registerClass:[RadioCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView registerClass:[RadioCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierForHeadView];
    // Do any additional setup after loading the view.
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
    NSInteger count = radioList.isExpend == YES ? radioList.radios.count : 0;
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
        headView.model = list;
        headView.tag = indexPath.section;
        headView.delegate = self;
    }
    return headView;
}


#pragma mark - <UICollectionViewFlowLayou>
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize currentSize = [UIScreen mainScreen].bounds.size;
    CGFloat width =( currentSize.width * 3.0 / 4.0 - 10 )/ 3.0;
    CGFloat height = width * ( 9.0 / 8.0 );
    return CGSizeMake(width, height);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize currentSize = [UIScreen mainScreen].bounds.size;
    CGSize size = {currentSize.width,45};
    return size;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
#pragma mark <UICollectionViewDelegate>
-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//点击某一项
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *imageView = [cell viewWithTag:10];
    imageView.layer.borderWidth = 2;
    imageView.layer.borderColor = [UIColor colorWithRed:58.f / 255.f green:181.f/255.f blue:231.f/255.f alpha:1].CGColor;
    
    RadioList *list = self.radios[indexPath.section];
    Radio *radio = list.radios[indexPath.row];
    RequestPlay *requst = [[RequestPlay alloc]init];
    requst.perantView = self.view;
    [requst getListAndPlayWithRadio:radio withPlayIndex:0];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *imageView = [cell viewWithTag:10];
    imageView.layer.borderWidth = 0;
}


#pragma mark - RadioListViewController
-(void)RadioCollectionHeadView:(RadioCollectionReusableView *)view headButtonClickWithInex:(NSInteger)index{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
    [self.collectionView reloadSections:indexSet];
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
