//
//  DragDownViewController.m
//  DragKeyboardDown
//
//  Created by Yimin Tu on 12-3-21.
//  Copyright (c) 2012年 dianping.com. All rights reserved.
//

#import "DragDownViewController.h"

@implementation DragDownViewController

- (void)keyboardWillChange:(NSNotification *)n {
    if(hideKeyboard)
        return;
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
    
    if([n.name isEqualToString:UIKeyboardWillShowNotification]) {
        maxOffset = -dy;
    }
}

- (void)keyboardDidChange:(NSNotification *)n {
    keyboardWindow = [self keyboardWindow];
    isKeyboardOn = keyboardWindow && [n.name isEqualToString:UIKeyboardDidShowNotification];
    if(isKeyboardOn) {
        beginKeyboard = keyboardWindow.frame;
        beginView = self.view.frame;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(isKeyboardOn) {
        CGFloat dy = beginOffset.y - scrollView.contentOffset.y;
        // drag 20px and keyboard will start move
        currentOffset = dy > 20 ? dy - 20 : 0;
        // avoid move too far
        currentOffset = currentOffset > maxOffset ? maxOffset : currentOffset;
        
        CGRect f = beginKeyboard;
        f.origin.y += currentOffset;
        keyboardWindow.frame = f;
        
        CGRect g = beginView;
        g.size.height += currentOffset;
        self.view.frame = g;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if(isKeyboardOn) {
        beginOffset = scrollView.contentOffset;
        currentOffset = 0;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    dragVelocity = velocity.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(isKeyboardOn) {
        hideKeyboard = currentOffset > maxOffset / 2;
        if(decelerate && dragVelocity < -0.4) {
            hideKeyboard = YES;
        }
        [UIView beginAnimations:@"keyboardDrag" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(dragAnimationDidStop:)];
        if(hideKeyboard) {
            CGRect rect = beginKeyboard;
            rect.origin.y += maxOffset;
            keyboardWindow.frame = rect;
            rect = beginView;
            rect.size.height += maxOffset;
            self.view.frame = rect;
        } else {
            keyboardWindow.frame = beginKeyboard;
            self.view.frame = beginView;
        }
        [UIView commitAnimations];
    } else {
        hideKeyboard = NO;
    }
}

- (void)dragAnimationDidStop:(id)sender {
    if(hideKeyboard) {
        keyboardWindow.hidden = YES;
        [self.text resignFirstResponder];
        hideKeyboard = NO;
        [self performSelector:@selector(didHide) withObject:nil afterDelay:0.3];
    }
}

- (void)didHide {
    keyboardWindow.frame = beginKeyboard;
    keyboardWindow.hidden = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row % 2) {
        case 1: {
            NSLog(@"%@", keyboardWindow.subviews);
            break;
        }
        default:
            [super tableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
    }
}

@end
