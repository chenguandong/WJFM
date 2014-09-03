//
//  DownLoadedViewController.h
//  DOUASDemo
//
//  Created by chenguandong on 14-6-10.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownLoadedViewController : BaseTableViewController
@property(nonatomic,strong) NSArray * allDownLoadData;

+(DownLoadedViewController *) sharedController;
-(void)startQueryData;
@end
