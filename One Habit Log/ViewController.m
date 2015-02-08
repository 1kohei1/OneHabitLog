//
//  ViewController.m
//  One Habit Log
//
//  Created by Kohei Arai on 2013/10/04.
//  Copyright (c) 2013年 Kohei Arai. All rights reserved.
//

#import "ViewController.h"
#import "TutorialView.h"
#import "ODRefreshControl.h"

/************ JASidePanel ************/
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

@interface ViewController () {
    /************ flag variable ************/
    BOOL labelFlag, ifLogged;
    
    /************ elements variable ************/
    UILabel *bottom;
    QBFlatButton *bottomButton;
    TSQCalendarView *calendar;
    
    /************ frame of UIView ************/
    CGRect frame;
    
    /************ selected date ************/
    NSDate *selectedDate;
    
    /************ tutorial variable ************/
    int page;
    UIScrollView *scroll;
    UIPageControl *pager;

    /************ log variable ************/
    UserLog *user_log;
    Habit *habit;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // UserLogのインスタンス作成
    user_log = [[UserLog alloc]init];
    
    // set labelFlag
    labelFlag = NO;
    
    // チュートリアルでのpage数を決定
    page = 4;
    
    // フレームをセットする
    [self setFrames];
    
    /************ set default view ************/
    // viewの背景色を決定
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1];
    
    // navigationBarのバックグラウンドを決定
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1];
    
    // 設定ボタンを表示
    UIBarButtonItem *setting = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"settings_32.png"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(settingButtonTapped:)];
    self.navigationItem.rightBarButtonItem = setting;
    /************ set default view ************/

    // チュートリアルに行くかカレンダーに行くかを決める
    NSArray *habits = [Habit MR_findAll];
    if ([habits count] == 0) {
        [self presentTutorial];
    } else {
        [self presentCalendar];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// present tutorial
- (void)presentTutorial {
    // ナビゲーションバーを非表示
    self.navigationController.navigationBar.hidden = YES;
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    // scrollを作成
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + (version >= 7.0 ? 20 : 0), frame.size.width, frame.size.height)];
    scroll.contentSize = CGSizeMake(frame.size.width * page, frame.size.height - 150);
    scroll.backgroundColor = [UIColor clearColor];
    scroll.userInteractionEnabled = YES;
    
    // ページング指定
    scroll.pagingEnabled = YES;
    
    // スクロールバーを表示しない
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    // ステータスバータップで上に戻らない。
    scroll.scrollsToTop = NO;
    // delegate
    scroll.delegate = self;
    
    // 画像を表示するviewを用意する
    TutorialView *tutorialView = [[TutorialView alloc]init];
    for (int i = 1; i <= page; i++) {
        tutorialView.page = i;
        tutorialView.width = frame.size.width;
        tutorialView.height = frame.size.height - 50;
        NSString *tutorial = [NSString stringWithFormat:@"tutorial%d", i];
        tutorialView.imageName = NSLocalizedString(tutorial, Nil);
        
        tutorialView.ifShowButton = (i == page ? YES : NO);
        UIView *oneTutorial = [tutorialView createView];

        [scroll addSubview:oneTutorial];
        
        if (page == 4) {
            QBFlatButton *button = [[QBFlatButton alloc]initWithFrame: CGRectMake(frame.size.width * (page - 1) + 20, frame.size.height - 130, frame.size.width - 40, 60)];
            button.titleLabel.font = [UIFont boldSystemFontOfSize: 20];
            NSString *buttonTitle = NSLocalizedString(@"tutorial_button", nil);
            [button setTitle:buttonTitle forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            // color
            button.faceColor = [UIColor colorWithRed:0.23 green:0.83 blue:.51 alpha:1];
            button.sideColor = [UIColor colorWithRed:.16 green:.76 blue:.44 alpha:1];
            
            [button addTarget:self action:@selector(endTutorialPresentCalendar) forControlEvents:UIControlEventTouchUpInside];
            [scroll addSubview:button];
        }
    }
    
    // pagerを作る
    pager = [[UIPageControl alloc]initWithFrame:CGRectMake((frame.size.width - 20) / 2, frame.size.height - 30, 20, 20)];
    pager.numberOfPages = page;
    pager.currentPage = 0;
    pager.pageIndicatorTintColor = [UIColor colorWithRed:0.84f green:0.85f blue:0.86f alpha:1.0f];
    pager.currentPageIndicatorTintColor = [UIColor blackColor];
    
    [pager addTarget:self action:@selector(changePageControl:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:pager];
    [self.view addSubview:scroll];
}

// tutorialを終え、カレンダーを表示する
- (void)endTutorialPresentCalendar {
    habit = [user_log createHabit];
    
    self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"center"];
    [self.sidePanelController showCenterPanelAnimated:NO];
}

// present calendar
- (void)presentCalendar {
    // ナビゲーションバーを表示
    self.navigationController.navigationBar.hidden = NO;
    
    // habitを取得
    habit = [user_log getSelectedHabit];
    if (!habit) {
        return;
    }
    
    // タイトルを表示
    self.navigationItem.title = habit ? habit.title : @"";

    // カレンダーを作成
    [self generateCalendar];
    [self.view addSubview:calendar];
    [calendar scrollToDate:[NSDate date] animated:NO];
    
    // bottom labelを作成
    bottom = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 100)];
    bottom.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [self.view addSubview:bottom];
    
    // bottomに表示させるボタン
    bottomButton = [[QBFlatButton alloc]initWithFrame: CGRectMake(20, frame.size.height + 20, frame.size.width - 40, 60)];
    // font
    bottomButton.titleLabel.font = [UIFont boldSystemFontOfSize: 20];
    [bottomButton setTitle:@"Mark" forState:UIControlStateNormal];
    [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // color
    bottomButton.faceColor = [UIColor colorWithRed:0.23 green:0.83 blue:.51 alpha:1];
    bottomButton.sideColor = [UIColor colorWithRed:.16 green:.76 blue:.44 alpha:1];
    // event
    [bottomButton addTarget:self action:@selector(markButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:bottomButton];
}
/************ view program end ************/


/************ delegate program (UIScrollview, UIPager, TSQCalendar) ************/
// scrollしたときのdelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // UIScrollViewのページ切替時イベント:UIPageControlの現在ページを切り替える処理
    pager.currentPage = scroll.contentOffset.x / frame.size.width;
}


// 日付が選択された
- (void)calendarView:(TSQCalendarView *)calendarView didSelectDate:(NSDate *)date {
    // bottomの文字を変更
    selectedDate = date;
    if ([user_log ifLogged:habit.id date:date]) {
        ifLogged = YES;
        [bottomButton setTitle:@"Unmark" forState:UIControlStateNormal];
    } else {
        ifLogged = NO;
        [bottomButton setTitle:@"Mark" forState:UIControlStateNormal];
    }
    
    if (!labelFlag) {
        [self showLabels:date];
        labelFlag = YES;
    }
}

// 選択された日付をそのまま選択してもいいかどうか
- (BOOL)calendarView:(TSQCalendarView *)calendarView shouldSelectDate:(NSDate *)date {
    NSComparisonResult result = [date compare:[NSDate date]];
    if (result != NSOrderedDescending) {
        return YES;
    } else {
        return NO;
    }
}

// run when TSQCalendarview scroll
- (void)calendarView:(TSQCalendarView *)calendarView didScroll:(int) random_num {
    if (random_num == 10) {
        [calendar setLastDate:[NSDate date]];
        [calendar reloadTable];
    }
    if (labelFlag) {
        [self hideLabels];
        labelFlag = NO;
    }
}
/************ delegate program end ************/


/************ action program (programs that runs by user action) ************/
// pagerのバリューに伴ってscrollも移動させる
- (void)changePageControl:(id)sender {
    // ページコントロールが変更された場合、それに合わせてページングスクロールビューを該当ページまでスクロールさせる
    CGRect Aframe = scroll.frame;
    Aframe.origin.x = frame.size.width * pager.currentPage;
    Aframe.origin.y = 0;
    // 可視領域まで移動
    [scroll scrollRectToVisible:Aframe animated:YES];
}

// マークボタンが押された。
- (void) markButtonTapped {
    if (ifLogged) { // Unmark
        [user_log deleteUserLog:habit.id date:selectedDate];
        ifLogged = NO;
    } else { // Mark
        [user_log insertUserLog:habit.id date:selectedDate];
        ifLogged = YES;
    }
    // カレンダーを更新
    labelFlag = NO;
    [calendar setSelectedDate:nil];
    [self hideLabels];
    [calendar reloadTable];
}

// settingボタンが押された。
- (void)settingButtonTapped:(UIBarButtonItem *)setting {
    self.sidePanelController.rightPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"setting"];
    [self.sidePanelController showRightPanelAnimated:YES];
}
/************ action program end ************/


/************ other methods (other program that helps code neat) ************/
// generate calendar
- (void)generateCalendar {
    calendar = [[TSQCalendarView alloc]initWithFrame:frame];
    calendar.habit_id = habit.id;
    
    // カレンダーの始めと終わりをきめる。
    Log *firstLog = [user_log getFirstLog:habit.id];
    
    calendar.delegate = self;
    calendar.firstDate = (firstLog ? firstLog.date : [NSDate date]);
    // calendar.firstDate = [NSDate dateWithTimeIntervalSinceNow:-8*24*60*60];
    calendar.lastDate = [NSDate date];
    calendar.backgroundColor = [UIColor clearColor];
}

// set frames
- (void)setFrames {
    frame = self.view.frame;
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    CGRect statusFrame = [[UIApplication sharedApplication]statusBarFrame];
    CGRect navFrame = self.navigationController.navigationBar.frame;
    
    // NSLocalizedStringのEnglishとJapaneseどちらが適用されるかを調べる
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [ud objectForKey:@"AppleLanguages"];

    int enIndex = [languages indexOfObject:@"en"];
    int jaIndex = [languages indexOfObject:@"ja"];
    
    float offset = (enIndex < jaIndex ? navFrame.size.height + (version < 7.0 ? 0 : statusFrame.size.height) : 0);
    
    frame = CGRectMake(0, 0, frame.size.width, frame.size.height - offset);
}

// ラベルを表示
- (void) showLabels:(NSDate *)date {
    [UIView animateWithDuration:0.5 animations:^{
        // bottomを移動
        bottom.frame = CGRectMake(0, frame.size.height - 100, frame.size.width, 100);
        bottomButton.frame = CGRectMake(20, frame.size.height - 80, frame.size.width - 40, 60);
        
        // flag切り替え
        labelFlag = YES;
    }];
}

// ラベルを非表示
- (void)hideLabels {
    [UIView animateWithDuration:0.5 animations:^{
        // bottomを移動
        bottom.frame = CGRectMake(0, frame.size.height, frame.size.width, 100);
        bottomButton.frame = CGRectMake(20, frame.size.height + 20, frame.size.width - 40, 60);
        
        // flag切り替え
        labelFlag = NO;
    }];
}
/************ other methods end ************/

@end
