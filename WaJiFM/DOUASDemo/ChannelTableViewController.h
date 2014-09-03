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
    @property(nonatomic,strong)NSArray *channelArray;
@property (weak, nonatomic) IBOutlet UIButton *headDownloadButton;
@property (weak, nonatomic) IBOutlet UIButton *headLoveButton;
@property (weak, nonatomic) IBOutlet MarqueeLabel *headTitle;
#pragma mark 
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
    @property(nonatomic,strong)MusicMenuBean *albumInfo;
@end
