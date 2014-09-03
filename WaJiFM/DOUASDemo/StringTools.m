//
//  StringTools.m
//  DOUASDemo
//
//  Created by chenguandong on 14-6-10.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import "StringTools.h"

@implementation StringTools
/**
    返回文件类型 1 voice 2 video
 */
+(int)getFileType:(NSString*)str{

    NSString *lstr  =[str lowercaseString];
    if(
       [lstr hasSuffix:@".mp3"]
       ||[lstr hasSuffix:@".aac"]
       ||[lstr hasSuffix:@".alac"]
       ||[lstr hasSuffix:@".he-aac"]
       
       ){
        return 1;
        }
    else if ([lstr hasSuffix:@".mov"]
             ||[lstr hasSuffix:@".mp4"]
              ||[lstr hasSuffix:@".m4v"]
               ||[lstr hasSuffix:@".3gp"]
             ){
        return 2;
    }
   
}
@end
