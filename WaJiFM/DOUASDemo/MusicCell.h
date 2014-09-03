//
//  MusicCell.h
//  DOUASDemo
//
//  Created by chenguandong on 14-6-13.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *musicImg;
@property (weak, nonatomic) IBOutlet UILabel *musicTitle;
@property (weak, nonatomic) IBOutlet UILabel *musicSubTitle;
@property (weak, nonatomic) IBOutlet UIButton *musicLove;
@property (weak, nonatomic) IBOutlet UIButton *musicDownloadButton;

@end
