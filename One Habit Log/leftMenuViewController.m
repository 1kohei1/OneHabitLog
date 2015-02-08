//
//  leftMenuViewController.m
//  One Habit Log
//
//  Created by Kohei Arai on 2013/12/02.
//  Copyright (c) 2013年 Kohei Arai. All rights reserved.
//

#import "leftMenuViewController.h"

/************ ライブラリ ************/
#import "ODRefreshControl.h"
#import "TSQCalendarView.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "calendarViewImage.h"

/************ きろく ************/
#import "UserLog.h"
#import "Habit.h"
#import "Log.h"

@interface leftMenuViewController () {
    /********** log variable **********/
    UserLog *user_log;
    NSArray *allHabit;
    calendarViewImage *calendarImage;
}

@end

@implementation leftMenuViewController

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
    
    // UserLogのインスタンスを作成
    user_log = [[UserLog alloc]init];
    
    // calendarViewImageのインスタンスを作成
    calendarImage = [[calendarViewImage alloc]init];
    
    // 引き下げて更新を作成
    ODRefreshControl *refresh = [[ODRefreshControl alloc]initInScrollView:self.table];
    CGRect refreshFrame = refresh.frame;
    refreshFrame.origin.x = -50;
    refresh.frame = refreshFrame;
    [refresh addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidLayoutSubviews {
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    CGRect tableFrame = self.table.frame;
    CGRect statusFrame = [[UIApplication sharedApplication] statusBarFrame];
    
    tableFrame = CGRectMake(tableFrame.origin.x, tableFrame.origin.y + (version >= 7.0 ? statusFrame.size.height : 0), tableFrame.size.width, tableFrame.size.height);
    
    self.table.frame = tableFrame;
}

- (void)viewDidAppear:(BOOL)animated {
//    [self adjustTableHeight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/************ delegate program ************/
//table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    allHabit = [user_log getNotDeletedHabit];
    return [allHabit count] + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    // UITableViewCellを作成
    static NSString *CellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == Nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    }

    // カスタムセルの要素を取得
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:101];
    
    if (indexPath.row < [allHabit count]) {
        // Habitを取得
        Habit *habit = [allHabit objectAtIndex:indexPath.row];
        
        // Habitのタイトルを表示するUILabelの編集
        label.text = [habit title];
        label.font = [habit.selected boolValue] ? [UIFont boldSystemFontOfSize:20.0] : [UIFont systemFontOfSize:17.0];
        label.textColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1.0 alpha:1];

        UIImage *image;
        // Calendarのイメージを取得
        if ([habit.secret boolValue]) {
            image = [UIImage imageNamed:@"lock.png"];
            label.text = NSLocalizedString(@"secret", nil);
        } else {
            image = [calendarImage getCalendarImage:habit.id imageFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
        }
        imageView.image = image;
    } else {
        // 新しいHabitを追加する際のLabelを編集
        label.text = NSLocalizedString(@"habit.title", Nil);
        label.font = [UIFont systemFontOfSize:17.0];
        label.textColor = [UIColor blackColor];
        
        // アイコンを表示
        imageView.image = [UIImage imageNamed:@"add.png"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Habit *showingHabit = indexPath.row < [allHabit count] ? [allHabit objectAtIndex:indexPath.row] : [user_log createHabit];
    NSLog(@"%@", showingHabit);
    if ([showingHabit.secret boolValue]) {
        // UIAlertViewでパスワードの入力を促す
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"secret", nil)
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"Submit", nil];
        alert.tag = indexPath.row; // allHabitの何番目かで指定されたHabitを読み込む
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[alert textFieldAtIndex:0] setPlaceholder:NSLocalizedString(@"password_placeholder", nil)];
        [alert show];
        
        return;
    }
    [user_log selectHabit:showingHabit.id];

    self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"center"];
}

//
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    Habit *secretHabit = [allHabit objectAtIndex:alertView.tag];
    NSString *input = [[alertView textFieldAtIndex:0] text];
    
    if (buttonIndex == 1) {
        if ([input isEqualToString:secretHabit.password]) {
            [user_log selectHabit:secretHabit.id];
            
            self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"center"];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"secret", nil)
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"Submit", nil];
            alert.tag = alertView.tag; // allHabitの何番目かで指定されたHabitを読み込む
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [[alert textFieldAtIndex:0] setPlaceholder:NSLocalizedString(@"password_placeholder", nil)];
            [alert show];
        }
    }
}
/************ delegate program end ************/


/************ other methods ************/
- (void)refresh:(ODRefreshControl *)refresh {
    [self.table reloadData];
    
    // そして0.3秒後に戻る
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refresh endRefreshing];
//        [self adjustTableHeight];
    });
}

@end
