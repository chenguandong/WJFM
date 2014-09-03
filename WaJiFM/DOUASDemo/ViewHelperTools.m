//
//  ViewHelperTools.m
//  WJFM
//
//  Created by chen.gd on 14-9-2.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import "ViewHelperTools.h"

@implementation ViewHelperTools

+(void)hiddenTableSeparator:(UITableView*)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];

}
@end
