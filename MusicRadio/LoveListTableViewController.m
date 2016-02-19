//
//  LoveListTableViewController.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/6.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "LoveListTableViewController.h"
#import "LoveManage.h"
#import "SongManage.h"
#import "PlayManage.h"
#import "RequestPlay.h"

@interface LoveListTableViewController ()
@property (nonatomic,strong) LoveManage *loveManager;
@end

@implementation LoveListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigation];
    self.loveManager = [LoveManage share];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.loveManager getLoveList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *useId = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:useId forIndexPath:indexPath];
//    if(!cell)
      UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:useId];
    SongManage *song = [self.loveManager getLoveList][indexPath.row];
    cell.textLabel.text = song.songName;
    return cell;
}


#pragma mark - Tabel view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RequestPlay *request = [[RequestPlay alloc]init];
    [request playLoveForArray:[self.loveManager getLoveList] withPlayIndex:indexPath.row];
//    PlayManage *play = [PlayManage sharePlay];
//    play.playIndex = (int)indexPath.row ;
//    play.music = [self.loveManager getLoveList];
//    NSLog(@"%ld",(long)indexPath.row);
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self.loveManager removeLoveForSong:[self.loveManager getLoveList][indexPath.row]];
        [tableView reloadData];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

#pragma mark - other
-(void)navigation{
    UINavigationItem *item = self.navigationItem;
    item.title = @"我的最爱";
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    item.leftBarButtonItem = left;
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
