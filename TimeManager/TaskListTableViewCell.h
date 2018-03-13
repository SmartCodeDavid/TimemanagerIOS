//
//  TaskListTableViewCell.h
//  Assign2
//
//  Created by David Lan on 24/4/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface TaskListTableViewCell : UITableViewCell 

@property (weak, nonatomic) IBOutlet UIButton *cellBtn;
@property (nonatomic,retain) UserInfo* userInfo;

@end
