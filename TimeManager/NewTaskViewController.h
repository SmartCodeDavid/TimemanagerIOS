//
//  NewTaskViewController.h
//  Assign2
//
//  Created by David Lan on 21/4/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface NewTaskViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    AppDelegate* _appDelegate;
}

@property (nonatomic,retain) AppDelegate* appDelegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *UrgentBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *setDateBtn;
@property (weak, nonatomic) IBOutlet UITextField *dueDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *uiCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
