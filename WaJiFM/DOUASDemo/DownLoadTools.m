//
//  DownLoadTools.m
//  DOUASDemo
//
//  Created by chenguandong on 14-6-9.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import "DownLoadTools.h"
#import "TCBlobDownload/TCBlobDownload.h"
#import "XMLBrodCastItem.h"
@implementation DownLoadTools
-(void)startAllDownload:(NSArray*)xmlBrodCastItems{

    for (XMLBrodCastItem *bean in xmlBrodCastItems) {
        TCBlobDownloader *download = [[TCBlobDownloader alloc] initWithURL:[NSURL URLWithString:bean.guid] downloadPath:kDownloadPath delegate:self];
        [[TCBlobDownloadManager sharedInstance] startDownload:download];
    }
    NSLog(@"开始下载");
}


- (void)download:(TCBlobDownloader *)blobDownload
  didReceiveData:(uint64_t)receivedLength
         onTotal:(uint64_t)totalLength
        progress:(float)progress
{
    NSLog(@"%f",progress);
}

- (void)download:(TCBlobDownloader *)blobDownload didReceiveFirstResponse:(NSURLResponse *)response
{
    
}

- (void)download:(TCBlobDownloader *)blobDownload didStopWithError:(NSError *)error
{
    
}
@end
