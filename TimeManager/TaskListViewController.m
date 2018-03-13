//
//  TaskListViewController.m
//  Assign2
//
//  Created by kit305 on 24/4/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import "TaskListViewController.h"
#import "TaskListTableViewCell.h"
#import "SortDropDownListCell.h"
#import "Enums.h"
#import "NewTaskViewController.h"
#import "ViewController.h"

@interface TaskListViewController ()

@end

@implementation TaskListViewController
@synthesize appDelegate;
@synthesize dropDownListTableView;
@synthesize sortDisplayBtn;
@synthesize InfotableView;


//An order option has been selected
- (void) btnInDropDownListPressDown:(id)sender{
    UIButton* btn = (UIButton*)sender;
    NSString* str = btn.currentTitle;
    if(dropDownListTableView.alpha == 0.0) {
        [UIView animateWithDuration:0.3 animations:^{
            dropDownListTableView.alpha = 1.0;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            dropDownListTableView.alpha = 0.0;
        }];
    }
    
    
    [sortDisplayBtn setTitle:str forState:UIControlStateNormal];
    
    if([btn.currentTitle isEqualToString:@"Urgency"]) {
        //rearrange order
        [self sortUserInArray:appDelegate.userInfoMutableArray SortBy:@"Urgency" StartIndex:0 EndIndex:appDelegate.userInfoMutableArray.count-1];
    }else{
        [self sortUserInArray:appDelegate.userInfoMutableArray SortBy:@"Due date" StartIndex:0 EndIndex:appDelegate.userInfoMutableArray.count-1];
    }
    
    //refresh tableview
    [InfotableView reloadData];
}

- (IBAction)backBtnPressDown:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//section of tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//number of items in tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView isEqual:dropDownListTableView]) {
        return 2;
    }else{
        return appDelegate.userInfoMutableArray.count;
    }
}

//build the each cell in tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:dropDownListTableView]) {
        SortDropDownListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DropDownListCell" forIndexPath:indexPath];
        
        if(!cell) {
            cell = (SortDropDownListCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DropDownListCell"];
        }
        
        NSArray *cellArrary = @[@"Due date",@"Urgency"];
        [cell.sortBtn setTitle:[cellArrary objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        [cell.sortBtn addTarget:self action:@selector(btnInDropDownListPressDown:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else{
        TaskListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ListTableCell" forIndexPath:indexPath];
        
        if(!cell) {
            cell = (TaskListTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListTableCell"] ;
        }
        
        UserInfo* userInfo = [appDelegate.userInfoMutableArray objectAtIndex:indexPath.row];
        NSString* strTitle = [NSString stringWithFormat:@"%@ %@", userInfo.name,userInfo.dueDate];
        cell.cellBtn.titleLabel.numberOfLines = 2;
        cell.userInfo = userInfo;
        [cell.cellBtn setTitle:strTitle forState:UIControlStateNormal];
        [cell.cellBtn addTarget:self action:@selector(btnInTableViewPressDown:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isEqual:dropDownListTableView]){
        return 30.f;
    }else{
        return 60.f;
    }
}

- (IBAction)btnInTableViewPressDown:(id)sender {
    //hide the dropdown list
    dropDownListTableView.alpha = 0.0;
    
    //pop up an alert
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Selection" message:@"Choose one of following options" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //Mark as edit mode
        appDelegate.ISINEDIT = YES;
        
        //grab the userInfo object
        UserInfo* userInfo = ((TaskListTableViewCell*)[[(UIButton*)sender superview] superview]).userInfo;
        
        //skip to the taskEdit page
        //grab instance from the storyboard with specific identifier.
        UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        NewTaskViewController* ntvc = [storyBoard instantiateViewControllerWithIdentifier:@"newTaskViewController"];
        appDelegate.editUserInfo = userInfo;
        ntvc.appDelegate = appDelegate;
        [self presentViewController:ntvc animated:YES completion:nil];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //find the index of the targeted object
        UIButton* btn = (UIButton*)sender;
        TaskListTableViewCell* currentCell =  (TaskListTableViewCell*)[[btn superview] superview];
        NSIndexPath* indexPath = [self.InfotableView indexPathForCell:currentCell];
        UserInfo *userInfo = nil;
        int index;
        
        for(int i = 0; i < appDelegate.userInfoMutableArray.count; i++) {
            userInfo = [appDelegate.userInfoMutableArray objectAtIndex:i];
            NSString* strUserInfo = [NSString stringWithFormat:@"%@ %@", userInfo.name, userInfo.dueDate];
            if([strUserInfo isEqualToString:btn.currentTitle]) {
                index = i;
                //update the database
                NSString* deleteQuery = [NSString stringWithFormat:@"delete from PersonInfo where name = '%@' and dueDate = '%@'", userInfo.name, userInfo.dueDate];
                BOOL res = [appDelegate.db executeUpdate:deleteQuery];
                if(!res) {
                    NSLog(@"Fail");
                }else{
                    //delete specific data source
                    [appDelegate.userInfoMutableArray removeObjectAtIndex:index];
                    //refresh the tableview
                    [self.InfotableView beginUpdates];
                    [self.InfotableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    [self.InfotableView endUpdates];
                    NSLog(@"Sccuess");
                }
                break;
            }
        }
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) sortUserInArray:(NSMutableArray* )userInfoMulArray SortBy:(NSString*) sortBy StartIndex:(NSInteger)startIndex EndIndex:(NSInteger)endIndex{
    //Quick sort
    if([sortBy isEqualToString:@"Due date"]) {
        if(startIndex >= endIndex){
            return;
        }
        UserInfo* userInfo = [userInfoMulArray objectAtIndex:startIndex];
        NSInteger temp = startIndex;
        
        for(NSInteger i = startIndex + 1; i <= endIndex; i++) {
            UserInfo* u = [userInfoMulArray objectAtIndex:i];
            if([self compareDate:userInfo.dueDate Day2:u.dueDate]){
                temp += 1;
                [userInfoMulArray exchangeObjectAtIndex:temp withObjectAtIndex:i];
                
            }
        }
        [userInfoMulArray exchangeObjectAtIndex:temp withObjectAtIndex:startIndex];
        [self sortUserInArray:userInfoMulArray SortBy:@"Due date" StartIndex:startIndex EndIndex:temp-1];
        [self sortUserInArray:userInfoMulArray SortBy:@"Due date" StartIndex:temp+1 EndIndex:endIndex];
        
    }else if([sortBy isEqualToString:@"Urgency"]){
        if(startIndex >= endIndex){
            return;
        }
        UserInfo* userInfo = [userInfoMulArray objectAtIndex:startIndex];
        NSInteger temp = startIndex;
        
        for(NSInteger i = startIndex + 1; i <= endIndex; i++) {
            UserInfo* u = [userInfoMulArray objectAtIndex:i];
            if([self compareUrgency:userInfo.urgent Urgency2:u.urgent]){
                temp += 1;
                [userInfoMulArray exchangeObjectAtIndex:temp withObjectAtIndex:i];
            }
        }
        [userInfoMulArray exchangeObjectAtIndex:temp withObjectAtIndex:startIndex];
        [self sortUserInArray:userInfoMulArray SortBy:@"Urgency" StartIndex:startIndex EndIndex:temp-1];
        [self sortUserInArray:userInfoMulArray SortBy:@"Urgency" StartIndex:temp+1 EndIndex:endIndex];
    }
}

- (BOOL) compareUrgency:(NSString*)urgency1 Urgency2:(NSString*)urgency2{
    urgency1 = [urgency1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    urgency1 = [urgency1 stringByReplacingOccurrencesOfString:@"&" withString:@""];
    urgency2 = [urgency2 stringByReplacingOccurrencesOfString:@" " withString:@""];
    urgency2 = [urgency2 stringByReplacingOccurrencesOfString:@"&" withString:@""];
    
    NSDictionary * urgency = @{
                                      @"URGENTIMPORTANT" : @"1",
                                      @"NOTURGENTIMPORTANT" : @"2",
                                      @"URGENTNOTIMPORTANT" : @"3",
                                      @"NOTURGENTNOTIMPORTANT" : @"4"
                                      };
    
    int levelUrgency1 = [[urgency valueForKey:urgency1] intValue];
    int levelUrgency2 = [[urgency valueForKey:urgency2] intValue];
    
    if(levelUrgency1 > levelUrgency2) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL) compareDate:(NSString*)day1 Day2:(NSString*)day2{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSDate* d1 = [df dateFromString:day1];
    NSDate* d2 = [df dateFromString:day2];
    
    NSComparisonResult rs = [d1 compare:d2];
    
    if(rs == NSOrderedAscending) {
        return  NO;
    }else{
        return YES;
    }
}
- (IBAction)showDropDownListBtnPressDown:(id)sender {
    if(dropDownListTableView.alpha == 1.0) {
        [UIView animateWithDuration:0.3 animations:^{
            dropDownListTableView.alpha = 0.0;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            dropDownListTableView.alpha = 1.0;
        }];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    dropDownListTableView.alpha = 0.0;
}

- (void) grabDataFromDatabase{
    //set database
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/db1.db"];
    appDelegate.userInfoMutableArray = [NSMutableArray array];
    appDelegate.db = [FMDatabase databaseWithPath:path];
    
    if(appDelegate.db != nil) {
        NSLog(@"database has been created");
        if([appDelegate.db open]){
            NSLog(@"database has been opened");
            // name; descrip dueDate urgent; unitCode; weight;
            NSString *stringCreateTable = @"create table if not exists PersonInfo(id integer primary key autoincrement, name varchar(20), descrip varchar(20), dueDate varchar(30), urgent varchar(30), unitCode varchar(20), weight integer)";
            if([appDelegate.db executeUpdate:stringCreateTable]) {
                NSLog(@"table has been created");
                
                NSString *stringSelect = @"select * from PersonInfo;";
                FMResultSet* rs = [appDelegate.db executeQuery:stringSelect];
                
                while([rs next]) {
                    UserInfo *userInfo = [[UserInfo alloc] init];
                    userInfo.name = [rs stringForColumn:@"name"];
                    userInfo.descrip = [rs stringForColumn:@"descrip"];
                    userInfo.dueDate = [rs stringForColumn:@"dueDate"];
                    userInfo.urgent = [rs stringForColumn:@"urgent"];
                    userInfo.unitCode = [rs stringForColumn:@"unitCode"];
                    userInfo.weight = [rs intForColumn:@"weight"];
                    [appDelegate.userInfoMutableArray addObject:userInfo];
                }
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{  //after finish the edit this event will be triggered
    //update the local array through grab the data from database
    [self grabDataFromDatabase];
    [self sortUserInArray:appDelegate.userInfoMutableArray SortBy:sortDisplayBtn.currentTitle StartIndex:0 EndIndex:appDelegate.userInfoMutableArray.count-1];
    NSLog(@"done");
    [self.InfotableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //[self sortUserInArray:appDelegate.userInfoMutableArray SortBy:sortDisplayBtn.currentTitle StartIndex:0 EndIndex:appDelegate.userInfoMutableArray.count-1];
    NSLog(@"done");
    dropDownListTableView.alpha = 0.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
