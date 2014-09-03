//
//  AlbumCellTableViewCell.h
//  DOUASDemo
//
//  Created by chenguandong on 14-6-13.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *albumImgView;
@property (weak, nonatomic) IBOutlet UILabel *albumTitle;
@property (weak, nonatomic) IBOutlet UILabel *albumSubTitle;

@end
