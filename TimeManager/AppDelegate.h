//
//  AppDelegate.h
//  Assign2
//
//  Created by David Lan on 8/4/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "FMDatabase.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) UserInfo* userInfo;
@property (nonatomic,retain) NSArray* MonthArray;
@property (nonatomic,assign) NSInteger currentMonthIndex;
@property (nonatomic,retain) UILabel*  currentHighlightLabel;
@property (nonatomic,retain) UILabel*  timeLabel;
@property (nonatomic,retain) UILabel*  eventLabel;
@property (nonatomic,retain) UINavigationController* navigation;
@property (nonatomic,retain) NSArray* urgencyArray;
@property (nonatomic,retain) FMDatabase* db;
@property (nonatomic,retain) NSMutableArray* userInfoMutableArray;
@property (nonatomic,assign) BOOL   ISINTIAL;
@property (nonatomic,assign) BOOL   ISINEDIT;
@property (nonatomic,retain) UserInfo* editUserInfo;

@end

