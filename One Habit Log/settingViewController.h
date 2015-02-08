//
//  settingViewController.h
//  One Habit Log
//
//  Created by Kohei Arai on 2013/12/03.
//  Copyright (c) 2013年 Kohei Arai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *save;

- (IBAction)saveANDclose:(id)sender;

@end
