//
//  ResizeViewController.m
//  DragKeyboardDown
//
//  Created by Yimin Tu on 12-3-21.
//  Copyright (c) 2012年 dianping.com. All rights reserved.
//

#import "ResizeViewController.h"

@implementation ResizeViewController
@synthesize tableView = _tableView;
@synthesize text = _text;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Resize";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChange:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChange:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // NOTE:
    // use [NSNotificationCenter removeObserver:self] here will also remove other observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardWillChange:(NSNotification *)n {
    NSLog(@"keyboardWillChange: name=%@, info=%@", n.name, n.userInfo);
    CGFloat duration = [(NSString *)[n.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = [(NSNumber *)[n.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGRect startRect = [(NSValue *)[n.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [(NSValue *)[n.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    {
        static BOOL skipNextNotification = NO;
        if(skipNextNotification) {
            skipNextNotification = NO;
            return;
        }
        if([n.name isEqualToString:UIKeyboardWillChangeFrameNotification]) {
            if(startRect.size.width == 0 && startRect.size.height == 0) {
                // this is a wired notification, just ignore it
                skipNextNotification = YES;
            }
            return;
        }
    }
    {
        // UIKeyboardFrameBeginUserInfoKey The key for an NSValue object containing a CGRect that identifies the start frame of the keyboard in screen coordinates. These coordinates do not take into account any rotation factors applied to the window’s contents as a result of interface orientation changes. Thus, you may need to convert the rectangle to window coordinates (using the convertRect:fromWindow: method) or to view coordinates (using the convertRect:fromView: method) before using it.
        
        UIWindow *myWindow = [self myWindow];
        UIWindow *keyboardWindow = [self keyboardWindow];
        startRect = [keyboardWindow convertRect:startRect fromWindow:myWindow];
        endRect = [keyboardWindow convertRect:endRect fromWindow:myWindow];
    }
    
    [UIView beginAnimations:@"keyboardChange" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    CGFloat dy = CGRectGetMinY(endRect) - CGRectGetMinY(startRect);
    CGRect r = self.view.frame;
    r.size.height += dy;
    self.view.frame = r;
    [UIView commitAnimations];
}

- (void)keyboardDidChange:(NSNotification *)n {
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"";
    switch (indexPath.row % 2) {
        case 0:
            cell.textLabel.text = @"Dismiss";
            break;
        case 1:
            cell.textLabel.text = @"Print Windows";
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row % 2) {
        case 0: {
            [self.text resignFirstResponder];
            break;
        }
        case 1: {
            NSLog(@"%@", [UIApplication sharedApplication].windows);
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (UIWindow *)myWindow {
    return [[UIApplication sharedApplication].windows objectAtIndex:0];
}
- (UIWindow *)keyboardWindow {
    NSArray *arr = [UIApplication sharedApplication].windows;
    for(UIWindow *w in arr) {
        NSString *wc = NSStringFromClass([w class]);
        if([wc isEqualToString:@"UITextEffectsWindow"]) {
            return w;
        }
    }
    return nil;
}

- (void)dealloc {
    [_tableView release];
    [_text release];
    [super dealloc];
}

@end
