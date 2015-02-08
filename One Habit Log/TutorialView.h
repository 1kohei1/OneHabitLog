//
//  TutorialView.h
//  One Habit Log
//
//  Created by Kohei Arai on 2013/10/07.
//  Copyright (c) 2013年 Kohei Arai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialView : UIView

// page
@property (nonatomic) int page;

// frame info
@property (nonatomic) float width;
@property (nonatomic) float height;

// showing image
@property (nonatomic) NSString *imageName;

// if button is shown
@property (nonatomic) BOOL ifShowButton;

- (UIView *)createView;

@end
