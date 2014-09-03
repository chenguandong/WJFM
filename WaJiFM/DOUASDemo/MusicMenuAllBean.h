//
//  MusicMenuAllBean.h
//  DOUASDemo
//
//  Created by chenguandong on 14-6-3.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicMenuAllBean : NSObject
@property(nonatomic,copy)NSString * categoryName;
@property(nonatomic,strong)NSMutableArray *subCategory;
@end
