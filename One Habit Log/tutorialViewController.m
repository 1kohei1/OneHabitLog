//
//  tutorialViewController.m
//  One Habit Log
//
//  Created by Kohei Arai on 2013/10/07.
//  Copyright (c) 2013年 Kohei Arai. All rights reserved.
//

#import "tutorialViewController.h"
#import "TutorialView.h"

@interface tutorialViewController ()

@end

@implementation tutorialViewController

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
    
    NSLog(@"hello");
    // scrollのframe指定
    /*
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height - 100);
    // ページング指定
    self.scroll.pagingEnabled = YES;
    
    // スクロールバーを表示しない
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.showsVerticalScrollIndicator = NO;
    // ステータスバータップで上に戻らない。
    self.scroll.scrollsToTop = NO;
    // delegate
    self.scroll.delegate = self;
     */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
