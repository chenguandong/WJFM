//
//  JsonTools.h
//  BBG
//
//  Created by chenguandong on 14-5-20.
//  Copyright (c) 2014年 chenguandong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonTools : NSObject
+(NSDictionary*)getJsonNSDictionary:(NSString*)jsonString;
+(NSArray*)getMusicMenuData:(NSString*)jsonString;
@end
