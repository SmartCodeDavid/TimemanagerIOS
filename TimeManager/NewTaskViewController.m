    //
//  NewTaskViewController.m
//  Assign2
//
//  Created by David Lan on 21/4/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import "NewTaskViewController.h"
#import "AppDelegate.h"
#import "UrgencyTableViewCell.h"

@interface NewTaskViewController ()

@end

@implementation NewTaskViewController

@synthesize appDelegate = _appDelegate;
@synthesize tableView;
@synthesize UrgentBtn;
@synthesize datePicker;
@synthesize setDateBtn;
@synthesize nameTextField;
@synthesize uiCodeTextField;
@synthesize descriptionTextField;
@synthesize dueDateTextField;
@synthesize weightTextField;
@synthesize titleLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@",self.appDelegate.currentHighlightLabel.text);
    [datePicker setHidden:YES];
    [setDateBtn setHidden:YES];
    if(_appDelegate.ISINEDIT) {  //edit mode
        nameTextField.textColor = [UIColor blackColor];
        uiCodeTextField.textColor = [UIColor blackColor];
        descriptionTextField.textColor = [UIColor blackColor];
        dueDateTextField.textColor = [UIColor blackColor];
        weightTextField.textColor = [UIColor blackColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"Task Edit";
        nameTextField.text = _appDelegate.editUserInfo.name;
        uiCodeTextField.text = _appDelegate.editUserInfo.unitCode;
        descriptionTextField.text = _appDelegate.editUserInfo.descrip;
        dueDateTextField.text = _appDelegate.editUserInfo.dueDate;
        weightTextField.text = [NSString stringWithFormat:@"%ld",(long)_appDelegate.editUserInfo.weight];
    }else{                       //task creation
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ConFirmBtnPressDown:(id)sender {
    //check all textField
    NSInteger comfirmNum = 0;
    for(id view in [self.view subviews]) {
        if([view isKindOfClass:[UITextField class]]) {
            UITextField *tf = (UITextField*) view;
            if(tf.hasText && CGColorEqualToColor(tf.textColor.CGColor, [UIColor blackColor].CGColor)) { //check each textfield
                //NSLog(@"123");
                comfirmNum++;
            }else{
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"You have incompleted contents" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
                break;
            }
        }
    }
    
    if(comfirmNum == 5) {               //can be submit to local database
        NSLog(@"submit");
        NSString* name = nameTextField.text;
        NSString* uiCode = uiCodeTextField.text;
        NSString* descrtiption = descriptionTextField.text;
        NSString* dueDate = dueDateTextField.text;
        NSString* urgent = UrgentBtn.titleLabel.text;
        NSInteger weight  = [weightTextField.text intValue];
        NSString* stringInsert;
        if(_appDelegate.ISINEDIT) { //edit mode ----> update modified infomation
            stringInsert = [NSString stringWithFormat:@"update PersonInfo set name='%@', descrip='%@', dueDate='%@',urgent='%@', unitCode='%@', weight='%ld' where name = '%@' and dueDate='%@'", name,descrtiption,dueDate,urgent,uiCode,(long)weight, _appDelegate.editUserInfo.name, _appDelegate.editUserInfo.dueDate];
        }else{
            // name; descrip dueDate urgent; unitCode; weight;
             stringInsert = [NSString stringWithFormat:@"INSERT INTO 'PersonInfo'('id','name', 'descrip', 'dueDate', 'urgent', 'unitCode', 'weight') VALUES (NULL,'%@','%@','%@','%@','%@',%ld)", name,descrtiption,dueDate, urgent, uiCode,(long)weight];
        }
        
        BOOL res = [_appDelegate.db executeUpdate:stringInsert];
        
        if(!res) {      //fail
            NSLog(@"fail");
        }else{          //success
            NSLog(@"success");
            _appDelegate.ISINEDIT = NO; //mark as finished editing
            
            //show the alert to tell user that the information has been submit successfully
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Submit successfully" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //return to home page
                [self dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
    
}
- (IBAction)backBtnPressDown:(id)sender {
    NSLog(@"%d", (int)_appDelegate.currentMonthIndex);
    _appDelegate.ISINEDIT = NO;         //exit the edit mode
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dateSetBtnPressDown:(id)sender {
    NSDate *date = datePicker.date;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    dueDateTextField.text = dateStr;
    [dueDateTextField setTextColor:[UIColor blackColor]];       //set color for the text
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm"];          //set this format to easily access by code.
    dateStr = [dateFormatter stringFromDate:date];
    NSLog(@"%@", dateStr);
    
    //close the datepicker
    [datePicker setHidden:YES];
    [setDateBtn setHidden:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.tag == 3) {
        [self.view endEditing:YES];
        [datePicker setHidden:NO];
        [setDateBtn setHidden:NO];
        return NO;
    }else{
        return YES;
    }
} 
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(_appDelegate.ISINEDIT) {   //edit mode -- 10:21 wed
        //keep the orignal text
    }else{
        //clear the orginal text
        textField.text = @"";
    }
    textField.textColor = [UIColor blackColor];
    if(textField.tag ==  3) {
        [datePicker setHidden:NO];
        [setDateBtn setHidden:NO];
    }else{
        [datePicker setHidden:YES];
        [setDateBtn setHidden:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (IBAction)dropDownListPressDown:(id)sender {
    
    //clear other possible responsers that has been shown on the view
    [self.view endEditing:YES];
    [datePicker setHidden:YES];
    [setDateBtn setHidden:YES];
    
    if(self.tableView.alpha > 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.alpha = 0.f;
        } completion:^(BOOL finished) {
            self.tableView.alpha = 0.f;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.tableView.alpha = 1.0;
        }];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation  {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UrgencyTableViewCell* utv = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    [utv.urgencyBtn setTitle:[NSString stringWithFormat:@"%@", _appDelegate.urgencyArray[indexPath.row]] forState:UIControlStateNormal];
    
    return  utv;
}

- (IBAction)btnInListPressDown:(id)sender {
    UIButton* btn =  (UIButton*)sender;
    [UrgentBtn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.alpha = 0.f;
    } completion:^(BOOL finished) {
        self.tableView.alpha = 0.f;
    }];
}



@end
