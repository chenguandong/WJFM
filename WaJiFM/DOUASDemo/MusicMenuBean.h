//
//  MusicMenuBean.h
//  DOUASDemo
//
//  Created by chenguandong on 14-6-3.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicMenuBean : NSObject
@property int ID;
    @property(nonatomic,copy)NSString * title;
  @property(nonatomic,copy)NSString * image;
  @property(nonatomic,copy)NSString * description;
  @property(nonatomic,copy)NSString * link;
  @property(nonatomic,copy)NSString * copyright;
    @property(nonatomic,copy)NSString *keywords;
@end
