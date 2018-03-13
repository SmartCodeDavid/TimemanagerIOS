//
//  Enums.h
//  Assign2
//
//  Created by David Lan on 26/4/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Enums : NSObject

typedef NS_ENUM(NSInteger,Urgency){
    URGENTIMPORTANT         = 1,
    NOTURGENTIMPORTANT      = 2,
    RGENTNOTIMPORTANT       = 3,
    NOTURGENTNOTIMPORTANT   = 4
};

@property (nonatomic,assign) Urgency urgency;

@end
