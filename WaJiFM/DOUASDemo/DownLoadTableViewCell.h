//
//  DownLoadTableViewCell.h
//  DOUASDemo
//
//  Created by chenguandong on 14-6-9.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownLoadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *sdImageView;
@property (weak, nonatomic) IBOutlet UILabel *sdTitle;
@property (weak, nonatomic) IBOutlet UIProgressView *sdProgress;
@property (weak, nonatomic) IBOutlet UILabel *sdSubTitle;

@end
