//
//  settingViewController.m
//  One Habit Log
//
//  Created by Kohei Arai on 2013/12/03.
//  Copyright (c) 2013年 Kohei Arai. All rights reserved.
//

#import "settingViewController.h"
#import "UserLog.h"
#import "Habit.h"

#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

@interface settingViewController () {
    /************ log variable ************/
    UserLog *user_log;
    Habit *habit;
    
    /************ keyboard flag variable ************/
    BOOL keyboardFlag;
}

@end

@implementation settingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // UserLogのインスタンスを作る
    user_log = [[UserLog alloc]init];
    
    // Habitを取得
    [self getSelectedHabit];

    // キーボードが出てきたときのnotificationを取得
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// frameをいじくる
- (void)viewDidLayoutSubviews {
    CGRect frame = self.toolBar.frame;
    CGRect tableFrame = self.table.frame;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (version >= 7.0) {
        frame.size.height += 20;
        tableFrame.size.height -= 20;
        tableFrame.origin.y += 20;
    }
    self.toolBar.frame = frame;
    self.table.frame = tableFrame;
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/************ delegate UITableView program ************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self getSelectedHabit];
    return habit ? 3 : 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"title_of_habit", nil);
            break;
        case 1:
            return NSLocalizedString(@"secret", nil);
            break;
        case 2:
            return NSLocalizedString(@"delete", nil);
            break;
        default:
            return @"";
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NSLocalizedString(@"title_of_habit_detail", nil);
            break;
        case 1:
            return NSLocalizedString(@"secret_detail", nil);
            break;
        case 2:
            return NSLocalizedString(@"delete_detail", nil);
            break;
        default:
            return @"";
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == Nil) {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGRect cellFrame = cell.contentView.frame;
    int section = indexPath.section;

    if (section == 0) { // habit title
        cell.tag = 10;
        
        // UITextFieldのframeを決める
        cellFrame.origin.x = 10;
        cellFrame.size.width -= 20;
        
        // UITextFieldを作る
        UITextField *habit_title = [[UITextField alloc]initWithFrame:cellFrame];
        habit_title.tag = 11;
        habit_title.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        habit_title.font = [UIFont systemFontOfSize:20];
        habit_title.delegate = self;
        habit_title.textAlignment = NSTextAlignmentCenter;
        habit_title.text = habit.title;
        habit_title.returnKeyType = UIReturnKeyDone;
        
        // UITextFieldをcellに加える
        [cell.contentView addSubview:habit_title];
    } else if (section == 1) { // secret
        int row = indexPath.row;
        if (row == 0) { // YES or NO to secret
            cell.tag = 20;

            // UILabelのframeを決める
            CGRect labelFrame = cellFrame;
            labelFrame.origin.x = 10;
            labelFrame.size.width = cellFrame.size.width / 2 - 20;
            
            // UILabelを作成
            UILabel *label = [[UILabel alloc]initWithFrame:labelFrame];
            label.backgroundColor = [UIColor clearColor];
            label.text = NSLocalizedString(@"secret", Nil);
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:20.0];
            
            // UILabelをcellに加える
            [cell.contentView addSubview:label];


            // UISwitchを作成する
            UISwitch *secret = [[UISwitch alloc]init];
            secret.tag = 21;
            secret.on = [habit.secret boolValue];
            secret.center = CGPointMake(cellFrame.size.width / 4 * 3, cellFrame.size.height / 2);
            [secret addTarget:self action:@selector(secretValueChanged:) forControlEvents:UIControlEventValueChanged];
            
            // UISwitchをcellに加える
            [cell.contentView addSubview:secret];
        } else { // pin code
            cell.tag = 30;
            
            // UILabelのframeを決める
            CGRect labelFrame = cellFrame;
            labelFrame.origin.x = 10;
            labelFrame.size.width = cellFrame.size.width / 2 - 20;
            
            // UILabelを作成
            UILabel *label = [[UILabel alloc]initWithFrame:labelFrame];
            label.backgroundColor = [UIColor clearColor];
            label.text = NSLocalizedString(@"secret_password", Nil);
            label.font = [UIFont systemFontOfSize:20.0];
            
            
            // UITextFieldのframeを決める
            CGRect passwordFrame = cellFrame;
            passwordFrame.origin.x = passwordFrame.size.width = cellFrame.size.width / 2;
            
            // UITextFieldを作成
            UITextField *password = [[UITextField alloc]initWithFrame:passwordFrame];
            password.tag = 31;
            password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            password.textAlignment = NSTextAlignmentCenter;
            password.font = [UIFont systemFontOfSize:20];
            password.delegate = self;
            password.text = habit.password;
            password.returnKeyType = UIReturnKeyDone;
            
            // disable cell by Habit
            if (![habit.secret boolValue]) {
                label.alpha = 0.2f;
                password.alpha = 0.2f;
                cell.userInteractionEnabled = NO;
            }
            
            // UILabelをcellにくわえる
            [cell.contentView addSubview:label];
            // UITextFieldをcellに加える
            [cell.contentView addSubview:password];
        }
    } else { // Delete Habit
        // 削除と表示するLabelを作る
        UILabel *label = [[UILabel alloc]initWithFrame:cellFrame];
        label.font = [UIFont systemFontOfSize:20.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = NSLocalizedString(@"delete", Nil);
        label.textColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1.0 alpha:1];
        label.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview:label];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert"
                                                       message:NSLocalizedString(@"delete_confirm", nil)
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:NSLocalizedString(@"delete", nil), nil];
        [alert show];
    }
}
/************ delegate UITableView program end ************/


/************ delegate UITextField program ************/
// keyboard notificationをコントロールする
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    keyboardFlag = textField.tag == 31 ? YES : NO;
}

// returnボタンを押したらキーボードを消す
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
/************ delegate UITextField program end ************/


/************ delegate UIAlertView program end ************/
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // Habitを削除
        [user_log deleteHabit:habit.id];
        
        // secretでない、なおかつdeletedでもないhabitを表示
        NSArray *availableHabit = [user_log getAvailableHabit];
        if ([availableHabit count] > 0) {
            Habit *newHabit = [availableHabit lastObject];
            [user_log selectHabit:newHabit.id];
        }
        
        self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"center"];
        [self.sidePanelController showCenterPanelAnimated:YES];
    }
}
/************ delegate UIAlertView program end ************/


/************ action program ************/
// secretの値が変化した
- (void)secretValueChanged:(UISwitch *)uiswitch {
    // パスワードを表示しているcellを取得
    UITableViewCell *cell = (UITableViewCell *)[self.table viewWithTag:30];
    
    if (uiswitch.on) { // Can edit
        cell.userInteractionEnabled = YES;
        
        for (UIView *subview in cell.contentView.subviews) {
            subview.alpha = 1.0f;
        }
    } else { // Cannot edit
        cell.userInteractionEnabled = NO;

        for (UIView *subview in cell.contentView.subviews) {
            subview.alpha = 0.2f;
        }
    }
}

// キーボードが現れた
-(void)keyboardWillShow:(NSNotification *)aNotification {
    if (keyboardFlag) {
        self.table.contentOffset = CGPointMake(0, 100);
    }
}

// キーボードが消えた
-(void)keyboardWillHide:(NSNotification *)aNotification {

}

- (void)getSelectedHabit {
    habit = [user_log getSelectedHabit];
}

// 変更を保存し、setting画面を閉じる
- (IBAction)saveANDclose:(id)sender {
    // section:0, row:0を取得
    UITableViewCell *cell10 = (UITableViewCell *)[self.table viewWithTag:10];
    
    // Habit titleを取得
    NSString *habit_title;
    for (UIView *subview in cell10.contentView.subviews) {
        if (subview.tag == 11) {
            UITextField *habit_title_field = (UITextField *)subview;
            habit_title = habit_title_field.text;
        }
    }
    
    // section:1, row:0を取得
    UITableViewCell *cell20 = (UITableViewCell *)[self.table viewWithTag:20];
    
    // secretを取得
    NSNumber *secret;
    for (UIView *subview in cell20.contentView.subviews) {
        if (subview.tag == 21) {
            UISwitch *uiswitch = (UISwitch *)subview;
            secret = [NSNumber numberWithBool:uiswitch.on];
        }
    }
    
    // section:1, row:1を取得
    UITableViewCell *cell30 = (UITableViewCell *)[self.table viewWithTag:30];
    
    // passwordを取得
    NSString *password;
    for (UIView *subview in cell30.contentView.subviews) {
        if (subview.tag == 31) {
            UITextField *password_field = (UITextField *)subview;
            password = password_field.text;
        }
    }
    
    // Habitが存在するなら
    if (habit) {
        [user_log updateHabit:habit.id title:habit_title secret:secret password:password];
    }
    self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"center"];
    [self.sidePanelController showCenterPanelAnimated:YES];
}
/************ action program end ************/


@end
