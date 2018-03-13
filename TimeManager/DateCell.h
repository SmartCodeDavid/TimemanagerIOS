//
//  DateCell.h
//  Assign2
//
//  Created by David Lan on 20/4/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface DateCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel* label;
@property (nonatomic,retain) UserInfo* userInfo;

@end
