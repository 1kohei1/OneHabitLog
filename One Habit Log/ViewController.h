//
//  ViewController.h
//  One Habit Log
//
//  Created by Kohei Arai on 2013/10/04.
//  Copyright (c) 2013年 Kohei Arai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSQCalendarView.h"
#import "QBFlatButton.h"
#import "UserLog.h"

@interface ViewController : UIViewController <TSQCalendarViewDelegate, UITableViewDelegate, UIAlertViewDelegate, UIScrollViewDelegate>

@property (nonatomic) int habit_id;

@end
