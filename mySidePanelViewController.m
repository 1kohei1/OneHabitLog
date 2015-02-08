//
//  mySidePanelViewController.m
//  One Habit Log
//
//  Created by Kohei Arai on 2013/12/02.
//  Copyright (c) 2013年 Kohei Arai. All rights reserved.
//

#import "mySidePanelViewController.h"
#import "UIViewController+JASidePanel.h"
#import "leftMenuViewController.h"
#import "settingViewController.h"

/************ log files ************/
#import "UserLog.h"
#import "Habit.h"

/************ TSQCalendarImage file ************/
#import "calendarViewImage.h"


@interface mySidePanelViewController () {
    UserLog *user_log;
    calendarViewImage *calendarImage;
}

@end

@implementation mySidePanelViewController

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
	// Do any additional setup after loading the view.
    
    self.delegate = self;
    
    // UserLogのインスタンス作成
    user_log = [[UserLog alloc]init];
    
    // calendarViewImageのインスタンス作成
    calendarImage = [[calendarViewImage alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)awakeFromNib{
    [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"leftMenu"]];
    [self setCenterPanel:(UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"center"]];
    [self setRightPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"setting"]];
    
    [self setLeftFixedWidth:200];
    [self setRightFixedWidth:250];
}

// delegate to detect when left panel is visible
- (void) JASidePanelControl:(JASidePanelController *)controller leftMenuVisible:(UIViewController *)viewController {
    leftMenuViewController *leftMenu = (leftMenuViewController *)viewController;
    [leftMenu.table reloadData];
    
    // 現在選択されているHabitを取得
    Habit *habit = [user_log getSelectedHabit];
    // そのカレンダービューを保存
    [calendarImage saveCalendarImage:habit.id imageFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
}

// delegate to detect when right panel is visible
- (void) JASidePanelControl:(JASidePanelController *)controller rightMenuVisible:(UIViewController *)viewController {
    settingViewController *settingVC = (settingViewController *)viewController;
    [settingVC.table reloadData];
}


@end
