//
//  DownLoadViewController.h
//  DOUASDemo
//
//  Created by chenguandong on 14-6-10.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownLoadViewController : BaseViewController<UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *pageContentSize;
@property (strong,nonatomic) UISegmentedControl * segment_title;
+(DownLoadViewController *) sharedController;

@end
