//
//  DownLoadTools.h
//  DOUASDemo
//
//  Created by chenguandong on 14-6-9.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCBlobDownload/TCBlobDownload.h"
const static NSString * DOWNLOAD_STOP = @"DOWNLOAD_STOP";
const static NSString * DOWNLOAD_START = @"DOWNLOAD_START";
@interface DownLoadTools : NSObject<TCBlobDownloaderDelegate>
-(void)startAllDownload:(NSArray*)xmlBrodCastItems;
@end
