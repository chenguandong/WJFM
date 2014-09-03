//
//  FavouriteTableViewController.h
//  DOUASDemo
//
//  Created by chenguandong on 14-6-15.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLBrodCastItem.h"

@interface FavouriteTableViewController : BaseTableViewController
@property(nonatomic,strong) NSMutableArray * allData;
@property(nonatomic,copy)NSString *querySql;


//删除收藏
-(BOOL)delectFavourite:(NSString*)title;
//检查是否已经收藏
-(BOOL)checkFavourite:(NSString*)title;
//插入收藏
-(BOOL)insertFavourite:(XMLBrodCastItem*)favouriteBean;

-(void)setSqlQuery:(NSString*)querySql;
@end
