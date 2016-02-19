//
//  SettingTableViewController.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/2/14.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "SettingTableViewController.h"
#import "Radio.h"
#import "RadioList.h"
#import "SettingManage.h"

@interface SettingTableViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *isAutoPlay;
@property (weak, nonatomic) IBOutlet UISwitch *failAutoGet;
@property (weak, nonatomic) IBOutlet UISwitch *useNoWifiRemind;
@property (weak, nonatomic) IBOutlet UIPickerView *fmType;

@property (nonatomic,strong) NSArray *radio;
@property (weak, nonatomic) IBOutlet UILabel *failGetCountLab;
@property (weak, nonatomic) IBOutlet UIStepper *failGetCountStepper;

@end

@implementation SettingTableViewController
+(instancetype)viewFormStory{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SettingTableViewController" bundle:nil];
    SettingTableViewController *settingTVC = [storyboard instantiateViewControllerWithIdentifier:@"SettingTVC"];
    return settingTVC;
}


-(void)viewDidLoad{
    [self navigation];
    [self loadSettingData];

}

#pragma mark other
-(void)navigation{
    UINavigationItem *item = self.navigationItem;
    item.title = @"设置";
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    item.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    item.rightBarButtonItem = right;
}

-(void)save{
    SettingManage *settingManager = [SettingManage share];
    settingManager.isAutoPlay = self.isAutoPlay.on;
    settingManager.failAutoGet = self.failAutoGet.on;
    settingManager.useNoWifiRemind = self.useNoWifiRemind.on;
    settingManager.fmIndex = [NSNumber numberWithInteger:[self.fmType selectedRowInComponent:0] ];
    settingManager.radioIndex = [NSNumber numberWithInteger:[self.fmType selectedRowInComponent:1]];
    settingManager.failCount = [NSNumber numberWithInt:[self.failGetCountLab.text intValue]];
    RadioList *list = self.radio[[settingManager.fmIndex intValue]];
    Radio *radio = list.radios[[settingManager.radioIndex intValue]];
    settingManager.radio = radio;
    
    
    BOOL result = [settingManager save];
    NSLog(@"save setting resutl = %@" ,result == YES ? @"success" : @"fail");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark table DataSoure
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat hieght ;
    if(indexPath.section == 0 && indexPath.row == 1)
        hieght = self.isAutoPlay.on == YES ? 120 : 0 ;
//    else if(indexPath.section == 0 && indexPath.row == 3)
//        hieght = self.failAutoGet.on == YES ? 75 : 0 ;
    else
        hieght = 44;
    return hieght;
}

#pragma mark table Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark PickView DataSoure
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0)
        return self.radio.count;
    int selectRow = (int)[pickerView selectedRowInComponent:0];
    RadioList *list = self.radio[selectRow];
    
    NSLog(@"selectRow = %d",selectRow);
    return list.radios.count;
}


#pragma mark PickView Delegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:{
            RadioList *list = self.radio[row];
            return list.name;
        }break;
        case 1:{
            int seletRow = (int)[pickerView selectedRowInComponent:0];
            RadioList *list = self.radio[seletRow];
            Radio *radio = list.radios[row];
            return radio.fmName;
        }break;
    }
    return @"";
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component == 0)
        [pickerView reloadComponent:1];
}

#pragma mark UITestField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if(textField.text.length >= 1)
        textField.text = [textField.text substringFromIndex:1];
    return YES;
}

#pragma Switch
- (IBAction)autoPlaySwitch:(UISwitch *)sender {
 //   BOOL isHidden =  sender.on;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    //[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView reloadData];
}
- (IBAction)failGetSwitch:(UISwitch *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
   // [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView reloadData];
}
- (IBAction)failAutoGet:(UISwitch *)sender {
}
- (IBAction)useNoWifiRemind:(UISwitch *)sender {
}

#pragma Stepper ValueChage
- (IBAction)failGetvalueChange:(UIStepper *)sender {
    self.failGetCountLab.text = [NSString stringWithFormat:@"%.0f",sender.value];
}

#pragma mark - 设置数据加载到控件
-(void)loadSettingData{
    SettingManage *settingManager = [SettingManage share];
    self.isAutoPlay.on = settingManager.isAutoPlay;
    self.failAutoGet.on = settingManager.failAutoGet;
    self.useNoWifiRemind.on = settingManager.useNoWifiRemind;
    [self.fmType selectRow:[settingManager.fmIndex intValue] inComponent:0 animated:YES];
    [self.fmType selectRow:[settingManager.radioIndex intValue] inComponent:1 animated:YES];
    self.failGetCountLab.text = [NSString stringWithFormat:@"%@",settingManager.failCount];
    self.failGetCountStepper.value = [settingManager.failCount intValue];
}

#pragma mark - 懒加载
-(NSArray *)radio{
    if(!_radio){
        _radio = [RadioList getRadios];
    }
    return _radio;
}




@end
