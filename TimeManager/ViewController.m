//
//  ViewController.m
//  Assign2
//
//  Created by David Lan on 8/4/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import "ViewController.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "DateCell.h"
#import "NewTaskViewController.h"
#import "FMDatabase.h"
#import <sqlite3.h>
#import "TaskListViewController.h"
#import "TMQViewController.h"

#define DATABASENAME @"userinfo.sqlite"

@interface ViewController ()

@end


@implementation ViewController

@synthesize timer                   = _timer;
@synthesize btn                     = _btn;
@synthesize circle                  = _circle;
@synthesize circleBackground        = _circleBackground;
@synthesize circleScore             = _circleScore;
@synthesize titleHome               = _titleHome;
@synthesize titleScore              = _titleScore;
@synthesize scoreValue              = _scoreValue;
@synthesize appDelegate             = _appDelegate;
@synthesize dataArray               = _dataArray;
@synthesize DateLabel;
@synthesize collectionView;
@synthesize timeLabel;
@synthesize eventLabel;


-(IBAction) puchButton{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://youtu.be/3KafgR2WEgY"]];
}

- (IBAction)TMQPressDown:(id)sender {
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    TMQViewController* tmq = [storyBoard instantiateViewControllerWithIdentifier:@"TMQViewController"];
    tmq.appDelegate = _appDelegate;
    [self presentViewController:tmq animated:YES completion:nil];
}

- (IBAction)listPressDown:(id)sender {
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    TaskListViewController* tlvc = [storyBoard instantiateViewControllerWithIdentifier:@"taskListViewController"];
    tlvc.appDelegate = _appDelegate;
    [self presentViewController:tlvc animated:YES completion:nil];
}

//set up the new task page.
- (IBAction)newEventPressDown:(id)sender {
    //grab instance from the storyboard with specific identifier.
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NewTaskViewController* ntvc = [storyBoard instantiateViewControllerWithIdentifier:@"newTaskViewController"];
    ntvc.appDelegate = _appDelegate;
    [self presentViewController:ntvc animated:YES completion:nil];
 //   ntvc.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
}

- (void) buildCollection
{
    _dataArray = [[NSMutableArray alloc] init];
    //[_dataArray addObjectsFromArray:@[@"MO",@"TU",@"WE",@"TH",@"FR",@"SA",@"SU"]];
    NSInteger currentMonth = _appDelegate.currentMonthIndex + 1;
    NSInteger index = 0;
    
    if(currentMonth == 4 || currentMonth == 6
           || currentMonth == 9 || currentMonth == 11
       ) {                                  //30 days
        index = 30;
    }else if(currentMonth == 2) {           //28 days
        index = 28;
    }else {                                 //31 days
        index = 31;
    }
    
    //generate the date displayer
    for(NSInteger i = 1; i <= index; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",(int)i];
        [_dataArray addObject:str];
    }
    
    DateLabel.text = _appDelegate.MonthArray[_appDelegate.currentMonthIndex];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (void) labelTap:(UITapGestureRecognizer *)recognizer
{
    //UILabel* label = (UILabel *)recognizer.view;
    DateCell* dataCell  = (DateCell*)recognizer.view;
    UILabel*  label     = dataCell.label;
    
    if(!_appDelegate.currentHighlightLabel) {
        _appDelegate.currentHighlightLabel = label;
    }else {
        _appDelegate.currentHighlightLabel.backgroundColor = [UIColor clearColor];
    }
    
    if([_appDelegate.currentHighlightLabel isEqual:dataCell.label]) {
        NSLog(@"yes");
        
    }else{
        [UIView animateWithDuration:1.f animations:^{
            [_appDelegate.timeLabel setAlpha:0.f];
            [_appDelegate.eventLabel setAlpha:0.f];
        }];
    }
    
    label.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:220/255.0 alpha:1.0];
    
    _appDelegate.currentHighlightLabel = label; 
    
    
    //display the time and relative event.
    _appDelegate.timeLabel.text = [dataCell.userInfo.dueDate substringWithRange:NSMakeRange(11, 5)];
    _appDelegate.eventLabel.text = dataCell.userInfo.descrip;
    [UIView animateWithDuration:1 animations:^{
        [_appDelegate.timeLabel setAlpha:1.f];
        [_appDelegate.eventLabel setAlpha:1.f];
        
    } completion:^(BOOL finished) {
//        [_appDelegate.timeLabel setAlpha:1.0];
//        [_appDelegate.eventLabel setAlpha:1.0];
    }];
}
    
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        DateCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DateCell" forIndexPath:indexPath];
    
        cell.label.text = _dataArray[indexPath.row];
        NSInteger month = _appDelegate.currentMonthIndex + 1;
        NSInteger day   = [cell.label.text intValue];
        for(UserInfo* userInfor in _appDelegate.userInfoMutableArray) {
            
            NSInteger m = [[userInfor.dueDate substringWithRange:NSMakeRange(5, 2)] intValue];
            NSInteger d = [[userInfor.dueDate substringWithRange:NSMakeRange(8, 2)] intValue];
            
            if(month == m && day == d) {
                cell.label.userInteractionEnabled = YES;
                //[cell.label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)]];
                [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)]];
                cell.label.textColor = [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1.0];
                cell.userInfo = userInfor;
                break;
            }else{
                cell.label.userInteractionEnabled = NO;
                cell.label.textColor = [UIColor whiteColor];
                cell.userInfo = nil;
            }
        }
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(20, 20);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void) displayControls {
    //Title
    //_titleHome = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x-60.f, 30.f, 120.f, 60.f)];
    
    //[_titleHome setText:@"TITLE"];
    //[_titleHome setTextColor:[UIColor whiteColor]];
    //_titleHome.font = [UIFont systemFontOfSize:45.f];
    //_titleHome.textAlignment = NSTextAlignmentCenter;
    
    
    _btn = [[UIButton alloc] init];
    [_btn setFrame:CGRectMake(200, 100, 40, 50)];
    [_btn setTitle:@"hello" forState:UIControlStateNormal];
    [_btn setBackgroundColor:[UIColor redColor]];
    
    //setting the background for home page
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    
    //score control
    _titleScore = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - 120, self.view.center.y - 80, 50, 30)];
    [_titleScore setTextColor:[UIColor whiteColor]];
    [_titleScore setText:@"TMQ"];
    [_titleScore setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:22.f]];
    
    //score Value
    _scoreValue = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - 125, self.view.center.y - 60, 50, 30)];
    [_scoreValue setTextColor:[UIColor whiteColor]];
//  [_scoreValue setFont:[UIFont preferredFontForTextStyle:uifo] ]
    [_scoreValue setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:24.f]];
    
    //[_scoreValue setFont:[UIFont systemFontOfSize:28.f]];
    [_scoreValue setTextAlignment:NSTextAlignmentCenter];
    [_scoreValue setText:@"0"];
    
    
    //date
    _appDelegate.MonthArray = @[@"JAN",@"FEB",@"MAR",@"APR",@"MAY",@"JUN",@"JUL",@"AUG",@"SEP",@"OCT",@"NOV",@"DEC"];
    _appDelegate.currentMonthIndex = 4; //default month is MAY
    [self buildCollection];
    
    //timelabel
    _appDelegate.timeLabel = timeLabel;
    _appDelegate.eventLabel = eventLabel;
    _appDelegate.eventLabel.backgroundColor = [UIColor colorWithRed:215/255.0 green:90/255.0 blue:84/255.0 alpha:0.0];
    _appDelegate.timeLabel.backgroundColor = [UIColor colorWithRed:215/255.0 green:90/255.0 blue:84/255.0 alpha:0.0];
    [_appDelegate.timeLabel setAlpha:0.f];
    [_appDelegate.eventLabel setAlpha:0.f];
    
    //three buttons at the bottom.

    
    //add those controls to the view
    [self.view addSubview:_titleHome];
    [self.view addSubview:_titleScore];
    [self.view addSubview:_scoreValue];
}

- (void) setCircle {
    
    //step1: setting the path to draw the circle
    _circle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(-50, 0) radius:60.f startAngle:0.f endAngle:6.3f clockwise:YES];
    
    //step2: creating CASHAPELAYER which will generate the circle with the path above. --- background
    _circleBackground = [CAShapeLayer layer];
    [_circleBackground setFrame:CGRectMake(0, 0, 100, 100)];
    _circleBackground.fillColor = [[UIColor clearColor] CGColor];
    _circleBackground.lineWidth = 20.f;
    _circleBackground.position = self.view.center;
    _circleBackground.strokeColor = [[UIColor colorWithRed:232/255.0 green:156/255.0 blue:12/255.0 alpha:1.0] CGColor];
    _circleBackground.strokeStart = 0.f;
    _circleBackground.strokeEnd = 1.f;
    _circleBackground.path = _circle.CGPath;
    
    //step3: creating CASHAPELAYER which display the percentages on the circle --- score
    _circleScore = [CAShapeLayer layer];
    [_circleScore setFrame:CGRectMake(0, 0, 100, 100)];
    _circleScore.fillColor = [[UIColor clearColor] CGColor];
    _circleScore.lineWidth = 20.f;
    _circleScore.position = self.view.center;
    _circleScore.strokeColor = [[UIColor colorWithRed:142/255.0 green:255/255.0 blue:13/255.0 alpha:1.0] CGColor];
    _circleScore.strokeStart = 0.f;
    _circleScore.strokeEnd = 0.f;
    _circleScore.path = _circle.CGPath;
    
    //step4: add those two circles to the view
    [self.view.layer addSublayer:_circleBackground] ;
    [self.view.layer addSublayer:_circleScore];
    
    //step5: show animation to the changes of percentage.
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(animatedPercentage) userInfo:nil repeats:YES];
    
}


- (void) animatedPercentage {
    if (((float)_circleScore.strokeEnd == _appDelegate.userInfo.scoreVal / 100.f)) {
        [_timer invalidate];
    } else {
        _circleScore.strokeEnd += 0.01;
        NSString *val = [[NSString alloc] initWithFormat:@"%d", (int)(_circleScore.strokeEnd * 100)];
        [_scoreValue setText:val];
    }
}
- (IBAction)previousBtnPressDown:(id)sender {
    _appDelegate.currentHighlightLabel.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:1.f animations:^{
        _appDelegate.timeLabel.alpha = 0.f;
        _appDelegate.eventLabel.alpha = 0.f;
    }];
    //_appDelegate.currentHighlightLabel = nil;
    if(--_appDelegate.currentMonthIndex >= 0) {
        //change the date header
        DateLabel.text = _appDelegate.MonthArray[_appDelegate.currentMonthIndex];
    }else {
        _appDelegate.currentMonthIndex = 11;        //back to Dec
    }
    
    //reload the current days information
    [self buildCollection];
    [self checkCollectionView];
    //[collectionView reloadData];
}

- (void) checkCollectionView{
    NSArray* arrayCells = [self.collectionView visibleCells];
    
    for(DateCell* cell in arrayCells) {
        NSInteger month = _appDelegate.currentMonthIndex + 1;
        NSInteger day   = [cell.label.text intValue];
        cell.label.textColor = [UIColor colorWithRed:226/255.0 green:253/255.0 blue:254/255.0 alpha:0.7];
        for(UserInfo* userInfor in _appDelegate.userInfoMutableArray) {
            
            NSInteger m = [[userInfor.dueDate substringWithRange:NSMakeRange(5, 2)] intValue];
            NSInteger d = [[userInfor.dueDate substringWithRange:NSMakeRange(8, 2)] intValue];
            
            if(month == m && day == d) {
                cell.label.userInteractionEnabled = YES;
                //[cell.label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)]];
                [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)]];
                cell.label.textColor = [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1.0];
                cell.userInfo = userInfor;
                break;
            }else{
                cell.label.userInteractionEnabled = NO;
                cell.label.textColor = [UIColor whiteColor];
                cell.userInfo = nil;
                [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doNothing:)]];
            }
        }
        if([cell.label.text intValue] <= _dataArray.count) {
            [cell setHidden:NO];
        }else{
            [cell setHidden:YES];
        }
     }
    
    
    
    NSLog(@"checkcOLL");
}

- (void) doNothing:(UITapGestureRecognizer *)recognizer{

}

- (IBAction)forwardBtnPressDown:(id)sender {
    _appDelegate.currentHighlightLabel.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:1.f animations:^{
        _appDelegate.timeLabel.alpha = 0.f;
        _appDelegate.eventLabel.alpha = 0.f;
    }];
    //_appDelegate.currentHighlightLabel = nil;
    if(++_appDelegate.currentMonthIndex <= 11) {
        DateLabel.text = _appDelegate.MonthArray[_appDelegate.currentMonthIndex];
    }else{
        _appDelegate.currentMonthIndex = 0;         //back to JAN
    }
    
    //reload the current days
    [self buildCollection];
    [self checkCollectionView];
    //[collectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [self setCircle];
    //grab the data from the database
    [self grabDataFromDatabase];
    //[self checkCollectionView];
    //[collectionView reloadData];
    if(! _appDelegate.ISINTIAL) {       //init uicollectionview
        //[self grabDataFromDatabase];
        //[collectionView reloadSections:[[NSIndexSet alloc] initWithIndex:0]];
        [collectionView reloadData];
        _appDelegate.ISINTIAL = YES;
    }else{
//        [self grabDataFromDatabase];
        [self checkCollectionView];
        //[collectionView reloadSections:[[NSIndexSet alloc] initWithIndex:0]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set delegate
    if(! _appDelegate) {
        _appDelegate = [[UIApplication sharedApplication] delegate];
        _appDelegate.userInfoMutableArray = [NSMutableArray array];
        _appDelegate.userInfo = [[UserInfo alloc] init];
        _appDelegate.userInfo.scoreVal = 0.f; //default score
        _appDelegate.urgencyArray = @[@"URGENT & IMPORTANT",@"NOT URGENT & IMPORTANT", @"URGENT & NOT IMPORTANT", @"NOT URGENT & NOT IMPORTANT"];
        _appDelegate.ISINTIAL = NO;
        _appDelegate.ISINEDIT = NO;
    }
    
    
    //grab the data from the database
    //[self grabDataFromDatabase];
    
    [self displayControls];
    //[self setCircle];
    
}

- (void) grabDataFromDatabase{
    //set database
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/db1.db"];
    _appDelegate.userInfoMutableArray = [NSMutableArray array];
    _appDelegate.db = [FMDatabase databaseWithPath:path];

    if(_appDelegate.db != nil) {
        NSLog(@"database has been created");
        if([_appDelegate.db open]){
            NSLog(@"database has been opened");
            // name; descrip dueDate urgent; unitCode; weight;
            NSString *stringCreateTable = @"create table if not exists PersonInfo(id integer primary key autoincrement, name varchar(20), descrip varchar(20), dueDate varchar(30), urgent varchar(30), unitCode varchar(20), weight integer)";
            if([_appDelegate.db executeUpdate:stringCreateTable]) {
                NSLog(@"table has been created");
                
                NSString *stringSelect = @"select * from PersonInfo;";
                FMResultSet* rs = [_appDelegate.db executeQuery:stringSelect];
                
                while([rs next]) {
                    UserInfo *userInfo = [[UserInfo alloc] init];
                    userInfo.name = [rs stringForColumn:@"name"];
                    userInfo.descrip = [rs stringForColumn:@"descrip"];
                    userInfo.dueDate = [rs stringForColumn:@"dueDate"];
                    userInfo.urgent = [rs stringForColumn:@"urgent"];
                    userInfo.unitCode = [rs stringForColumn:@"unitCode"];
                    userInfo.weight = [rs intForColumn:@"weight"];
                    [_appDelegate.userInfoMutableArray addObject:userInfo];
                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
