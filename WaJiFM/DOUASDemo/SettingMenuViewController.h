//
//  SettingMenuViewController.h
//  DOUASDemo
//
//  Created by chenguandong on 14-6-13.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingMenuViewController : BaseViewController<UITableViewDataSource,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *arr;
@end
