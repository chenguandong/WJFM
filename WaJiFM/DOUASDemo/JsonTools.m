//
//  JsonTools.m
//  BBG
//
//  Created by chenguandong on 14-5-20.
//  Copyright (c) 2014年 chenguandong. All rights reserved.
//

#import "JsonTools.h"
#import "HttpTools.h"
#import "MusicMenuAllBean.h"
#import "MusicMenuBean.h"
@implementation JsonTools

+(NSDictionary*)getJsonNSDictionary:(NSString *)jsonString{
    NSData *data =  [ jsonString  dataUsingEncoding:NSUTF8StringEncoding];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *JsonObjectAll = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

    
    return JsonObjectAll;
}


#pragma mark--城市Json解析
//+(NSMutableArray*)getCityBeans:(NSString*)jsonString{
//    
//    NSMutableArray *cityBeans = [[NSMutableArray alloc]init];
//
//    NSDictionary *jsonAll = [self getJsonNSDictionary:jsonString];
//    
//    NSArray * allArray  =  [jsonAll objectForKey:@"disJson"];
//    
//    for (NSDictionary * bean in allArray) {
//        CityBean *cityBean = [[CityBean alloc]init];
//        cityBean.districtId = [[bean objectForKey:@"districtId"]intValue] ;
//        
//        cityBean.districtName = [bean objectForKey:@"districtName"];
//        
//        cityBean.parentId=[[bean objectForKey:@"parentId"]intValue] ;
//        cityBean.isLast = [[bean objectForKey:@"isLast"]intValue];
//
//        [cityBeans addObject:cityBeans];
//        
//    }
//    return cityBeans;
//}

+(NSArray*)getMusicMenuData:(NSString*)jsonString{

   // NSMutableArray *menuData = [[NSMutableArray alloc]init];
    
    NSData *data =  [ jsonString  dataUsingEncoding:NSUTF8StringEncoding];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSArray *JsonObjectAll = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    NSMutableArray *array = [NSMutableArray new];
    
    for (NSDictionary *dic in JsonObjectAll) {
        MusicMenuAllBean *allBean  = [MusicMenuAllBean new];
        allBean.categoryName = [dic objectForKey:@"categoryName"];
        NSMutableArray *arr = [NSMutableArray new];
        for (NSDictionary *dd in [dic objectForKey:@"subCategory"]) {
            
            
            MusicMenuBean *bean  = [MusicMenuBean new];
            
            bean.title = [dd objectForKey:@"title"];
            bean.image = [dd objectForKey:@"image"];
            bean.description = [dd objectForKey:@"description"];
            bean.link = [dd objectForKey:@"link"];
            bean.copyright = [dd objectForKey:@"copyright"];
   
            [arr addObject:bean];

        }
        
        allBean.subCategory=arr;
        
        [array addObject:allBean];
    }
    
    return array;

}


@end
