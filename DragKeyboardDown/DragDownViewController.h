//
//  DragDownViewController.h
//  DragKeyboardDown
//
//  Created by Yimin Tu on 12-3-21.
//  Copyright (c) 2012年 dianping.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollViewController.h"

@interface DragDownViewController : ScrollViewController
<UIScrollViewDelegate>
{
    BOOL isKeyboardOn;
    UIWindow *keyboardWindow; // set in UIKeyboardDidShowNotification
    
    CGPoint beginOffset;
    CGRect beginKeyboard;
    CGRect beginView;
    CGFloat currentOffset;
    CGFloat maxOffset;
    
    CGFloat dragVelocity;
    BOOL hideKeyboard;
}

@end
