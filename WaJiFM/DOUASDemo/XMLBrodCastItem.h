//
//  XMLBrodCastItem.h
//  DOUASDemo
//
//  Created by chenguandong on 14-5-29.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLBrodCastItem : NSObject
@property int ID;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * author;
@property(nonatomic,copy)NSString * subtitle;
@property(nonatomic,copy)NSString * summary;
@property(nonatomic,copy)NSString * image;
/*!
 *  播放地址
 */
@property(nonatomic,copy)NSString * guid;
@property(nonatomic,copy)NSString * pubDate;
@property(nonatomic,copy)NSString * duration;
@property(nonatomic,copy)NSString * keywords;

/**
    1,  正在下载
    2,  暂停
    3,  下载完毕
 */
@property int download_type;

//下载完毕后文件名称
@property (nonatomic,copy)NSString *download_file_name;

//所属专辑名称
@property(nonatomic,copy)NSString *album;

//文件类型  1, voice 2, voideo

@property int file_type;


////加入收藏
// 0 no 1 yes
@property(nonatomic)BOOL isfavourite;

@end
