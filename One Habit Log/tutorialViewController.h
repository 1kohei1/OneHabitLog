//
//  tutorialViewController.h
//  One Habit Log
//
//  Created by Kohei Arai on 2013/10/07.
//  Copyright (c) 2013年 Kohei Arai. All rights reserved.
//

#import "ViewController.h"

@interface tutorialViewController : ViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIPageControl *pager;

@end
