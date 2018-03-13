//
//  ViewController.h
//  Assign2
//
//  Created by David Lan on 8/4/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSTimer*         _timer;
    UIButton*        _btn;
    UIBezierPath*    _circle;
    CAShapeLayer*    _circleBackground;
    CAShapeLayer*    _circleScore;
    UILabel*         _titleHome;
    UILabel*         _titleScore;
    UILabel*         _scoreValue;
    AppDelegate*     _appDelegate;
    NSMutableArray*     _dataArray;
    
}

@property (nonatomic,retain) NSTimer*       timer;
@property (nonatomic,retain) UIButton*      btn;
@property (nonatomic,retain) UIBezierPath*  circle;
@property (nonatomic,retain) CAShapeLayer*  circleBackground;
@property (nonatomic,retain) CAShapeLayer*  circleScore;
@property (nonatomic,retain) UILabel*       titleHome;
@property (nonatomic,retain) UILabel*       titleScore;
@property (nonatomic,retain) UILabel*       scoreValue;
@property (nonatomic,retain) AppDelegate*   appDelegate;
@property (nonatomic,strong) NSMutableArray* dataArray;
@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;
@property (nonatomic,weak) IBOutlet UIButton* previousDateBtn;
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;
@property (weak, nonatomic) IBOutlet UIButton *forwardDateBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLabel;


@end



