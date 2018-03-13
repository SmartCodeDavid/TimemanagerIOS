//
//  TaskListViewController.h
//  Assign2
//
//  Created by kit305 on 24/4/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TaskListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,retain) AppDelegate* appDelegate;
@property (weak, nonatomic) IBOutlet UITableView *dropDownListTableView;
@property (weak, nonatomic) IBOutlet UIButton *sortDisplayBtn;
@property (weak, nonatomic) IBOutlet UITableView *InfotableView;

@end
