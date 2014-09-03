//
//  HttpTools.m
//  BBG
//
//  Created by chenguandong on 14-5-19.
//  Copyright (c) 2014年 chenguandong. All rights reserved.
//

#import "HttpTools.h"

@implementation HttpTools
+(AFHTTPRequestOperationManager*)getAFHTTPRequestOperationManager{
    //  准备请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 根据自己的服务器来设定 text/plain或其它
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/plain", nil];
    return manager;
}



@end
