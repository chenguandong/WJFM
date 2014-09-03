//
//  HistoryTableViewController.h
//  哇唧FM
//
//  Created by chen.gd on 14-8-25.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//
//  播放的历史记录

#import <UIKit/UIKit.h>
#import "FavouriteTableViewController.h"
@interface HistoryTableViewController :BaseTableViewController
@property(nonatomic,strong) NSMutableArray * historyAllData;
@property(nonatomic,copy)NSString *querySql;

@end
