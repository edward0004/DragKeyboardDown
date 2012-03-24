//
//  ViewController.m
//  DragKeyboardDown
//
//  Created by Yimin Tu on 12-3-21.
//  Copyright (c) 2012年 dianping.com. All rights reserved.
//

#import "ViewController.h"
#import "ResizeViewController.h"
#import "ScrollViewController.h"
#import "DragDownViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Drag Keyboard Down";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"resize with keyboard";
            break;
        case 1:
            cell.textLabel.text = @"scroll & resize when table on foot";
            break;
        case 2:
            cell.textLabel.text = @"drag down keyboard";
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            ResizeViewController *view = [[ResizeViewController alloc] initWithNibName:@"ResizeViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:view animated:YES];
            [view release];
            break;
        }
        case 1: {
            ScrollViewController *view = [[ScrollViewController alloc] initWithNibName:@"ResizeViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:view animated:YES];
            [view release];
            break;
        }
        case 2: {
            DragDownViewController *view = [[DragDownViewController alloc] initWithNibName:@"ResizeViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:view animated:YES];
            [view release];
            break;
        }
        default:
            break;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
