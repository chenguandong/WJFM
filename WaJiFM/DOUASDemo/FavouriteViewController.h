//
//  FavouriteViewController.h
//  DOUASDemo
//
//  Created by chenguandong on 14-6-15.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavouriteViewController : BaseViewController<UIPageViewControllerDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *awgment;
@property (weak, nonatomic) IBOutlet UIView *pageView;
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *pageContentSize;
@end
