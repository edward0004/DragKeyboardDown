//
//  ResizeViewController.h
//  DragKeyboardDown
//
//  Created by Yimin Tu on 12-3-21.
//  Copyright (c) 2012年 dianping.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResizeViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UITextField *text;

- (UIWindow *)myWindow;
- (UIWindow *)keyboardWindow;

@end
