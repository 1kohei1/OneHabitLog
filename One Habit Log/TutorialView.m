//
//  TutorialView.m
//  One Habit Log
//
//  Created by Kohei Arai on 2013/10/07.
//  Copyright (c) 2013年 Kohei Arai. All rights reserved.
//

#import "TutorialView.h"
#import "QBFlatButton.h"

@implementation TutorialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

// create view
- (UIView *)createView {
    // 大本になるviewを作成する
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(_width * (_page - 1), 0, _width, _height)];
    
    // チュートリアルに使う画像をセット
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _width, (_page == 4 ? _height - 100 : _height))];
    imageView.image = [UIImage imageNamed:_imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imageView];
    
    return view;
}

@end
