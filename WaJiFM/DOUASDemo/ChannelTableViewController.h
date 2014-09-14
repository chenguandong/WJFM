//
//  ChannelTableViewController.h
//  DOUASDemo
//
//  Created by chenguandong on 14-6-4.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCBlobDownload.h"
#import "MusicMenuBean.h"
@class MarqueeLabel;
@interface ChannelTableViewController : BaseTableViewController
//当前显示的数据
@property(nonatomic,strong)NSMutableArray *channelArray;
//总数据
@property(nonatomic,strong)NSArray *allChannelArray;
@property (weak, nonatomic) IBOutlet UILabel *loadMoreText;

@property (weak, nonatomic) IBOutlet UIButton *headDownloadButton;
@property (weak, nonatomic) IBOutlet UIButton *headLoveButton;
@property (weak, nonatomic) IBOutlet MarqueeLabel *headTitle;
@property (strong, nonatomic) IBOutlet UIView *loadMoreView;
@property (weak, nonatomic) IBOutlet UIImageView *headBgView;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
    @property(nonatomic,strong)MusicMenuBean *albumInfo;
@end
