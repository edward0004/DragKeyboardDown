//
//  ScrollViewController.m
//  DragKeyboardDown
//
//  Created by Yimin Tu on 12-3-21.
//  Copyright (c) 2012年 dianping.com. All rights reserved.
//

#import "ScrollViewController.h"

@implementation ScrollViewController

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
    
    // has table view scroll to foot?
    BOOL scrollBottom = self.tableView.contentOffset.y + self.tableView.frame.size.height > self.tableView.contentSize.height - 20;
    
    [UIView beginAnimations:@"keyboardChange" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    CGFloat dy = CGRectGetMinY(endRect) - CGRectGetMinY(startRect);
    CGRect r = self.view.frame;
    r.size.height += dy;
    self.view.frame = r;
    
    // only scroll when keyboard shows
    if(scrollBottom && [n.name isEqualToString:UIKeyboardWillShowNotification]) {
        CGFloat h = self.tableView.frame.size.height;
        CGSize contentSize = self.tableView.contentSize;
        [self.tableView setContentOffset:CGPointMake(0, contentSize.height - h) animated:NO];
        // we are already in animation, so set animation=NO
    }
    
    [UIView commitAnimations];
}

@end
