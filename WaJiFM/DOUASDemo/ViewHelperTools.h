//
//  ViewHelperTools.h
//  WJFM
//
//  Created by chen.gd on 14-9-2.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewHelperTools : NSObject
/*!
 *  隐藏UITableView多余的分割线
 *
 *  @param tableView 要操作的UITableView
 */
+(void)hiddenTableSeparator:(UITableView*)tableView;
@end
