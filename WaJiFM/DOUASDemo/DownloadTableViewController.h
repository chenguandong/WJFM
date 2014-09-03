//
//  DownloadTableViewController.h
//  DOUASDemo
//
//  Created by chenguandong on 14-6-7.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCBlobDownload.h"
@interface DownloadTableViewController : BaseTableViewController<TCBlobDownloaderDelegate>

@property(nonatomic,strong) NSMutableArray * allDownLoadData;

+(DownloadTableViewController *) sharedController;

-(void)startDownLoad;

@end
