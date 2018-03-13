//
//  UserInfo.h
//  Assign2
//
//  Created by David Lan on 20/4/17.
//  Copyright © 2017 David Lan. All rights reserved.
//


/*
    Description: userInfo, in other words, eventInfo
    members    : name,descrip,dueDate,urgent,unitCode,weight
 
 */
#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
{
    float _scoreVal;
    NSString* _name;
    NSString* _descrip;
    NSString* _dueDate;
    NSString* _urgent;
    NSString* _unitCode;
    NSInteger _weight;
}

@property (nonatomic,assign) float scoreVal;
@property (nonatomic,retain) NSString* name;
@property (nonatomic,retain) NSString* descrip;
@property (nonatomic,retain) NSString* dueDate;
@property (nonatomic,retain) NSString* urgent;
@property (nonatomic,retain) NSString* unitCode;
@property (nonatomic,assign) NSInteger weight;

@end



