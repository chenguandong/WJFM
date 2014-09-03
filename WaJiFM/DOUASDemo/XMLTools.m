//
//  XMLTools.m
//  DOUASDemo
//
//  Created by chenguandong on 14-5-29.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import "XMLTools.h"
#import "GDataXMLNode.h"
#import "XMLBrodCast.h"
#import "XMLBrodCastItem.h"
@implementation XMLTools

//
+(NSDictionary*)getBrodCastXML:(NSString *)xmlURL{
//http://www.ximalaya.com/album/203355.xml
    NSMutableDictionary *dic = [NSMutableDictionary new];
    NSMutableArray *array = [NSMutableArray new];
    
    
    NSLog(@"开始解析");
    
    NSData *xmlData  = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:xmlURL]];
    //使用NSData对象初始化

    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData  options:0 error:nil];
    
    //获取根节点（Users）
    GDataXMLElement *rootElement = [doc rootElement];

    //获取根节点下的节点（User）
    XMLBrodCast *xmlBrodCase = [XMLBrodCast new];

        NSArray *channels = [rootElement elementsForName:@"channel"];
    
        for (GDataXMLElement *channel in channels) {
            ///////

            //获取age节点的值
            GDataXMLElement *copyright = [[channel elementsForName:@"itunes:keywords"] objectAtIndex:0];
            xmlBrodCase.copyright =[copyright stringValue];
            
            GDataXMLElement *link = [[channel elementsForName:@"link"] objectAtIndex:0];
            xmlBrodCase.link =[link stringValue];
            
            GDataXMLElement *title = [[channel elementsForName:@"title"] objectAtIndex:0];
            xmlBrodCase.title =[title stringValue];
            
            GDataXMLElement *keywords = [[channel elementsForName:@"itunes:keywords"] objectAtIndex:0];
            xmlBrodCase.keywords =[keywords stringValue];
            
            
            GDataXMLElement *author = [[channel elementsForName:@"itunes:authors"] objectAtIndex:0];
            xmlBrodCase.author =[author stringValue];
            
            
            GDataXMLElement *subtitle = [[channel elementsForName:@"itunes:subtitle"] objectAtIndex:0];
            xmlBrodCase.subtitle =[subtitle stringValue];
            
            
            GDataXMLElement *summary = [[channel elementsForName:@"itunes:summary"] objectAtIndex:0];
            xmlBrodCase.summary =[summary stringValue];
            
            GDataXMLElement *description = [[channel elementsForName:@"description"] objectAtIndex:0];
            xmlBrodCase.description =[description stringValue];
            
            
            GDataXMLElement *image = [[channel elementsForName:@"image"] objectAtIndex:0];
            xmlBrodCase.image =[image stringValue];
   
            [dic setObject:xmlBrodCase forKey:@"items"];
            NSLog(@"%@",xmlBrodCase.title);
            NSLog(@"%@",xmlBrodCase.keywords);
            NSLog(@"%@",xmlBrodCase.link);
            NSLog(@"#################################");
            
           NSArray *items =  [channel elementsForName:@"item"];
            
            for (GDataXMLElement *item in items) {
                
                XMLBrodCastItem *xmlBridCaseItem = [XMLBrodCastItem new];
                //获取age节点的值
                GDataXMLElement *title = [[item elementsForName:@"title"] objectAtIndex:0];
                xmlBridCaseItem.title =[title stringValue];
                
                
                GDataXMLElement *author = [[item elementsForName:@"itunes:author"] objectAtIndex:0];
                xmlBridCaseItem.author =[author stringValue];
                
                
                GDataXMLElement *subtitle = [[item elementsForName:@"itunes:subtitle"] objectAtIndex:0];
                xmlBridCaseItem.subtitle =[subtitle stringValue];
                
                
                GDataXMLElement *summary = [[item elementsForName:@"itunes:summary"] objectAtIndex:0];
                xmlBridCaseItem.summary =[summary stringValue];
                
                
                GDataXMLElement *image = [[item elementsForName:@"itunes:image"] objectAtIndex:0];
                xmlBridCaseItem.image =[[image attributeForName:@"href"]stringValue];
                

                GDataXMLElement *guid = [[item elementsForName:@"guid"] objectAtIndex:0];
                xmlBridCaseItem.guid =[guid stringValue];
                
                GDataXMLElement *pubDate = [[item elementsForName:@"pubDate"] objectAtIndex:0];
                xmlBridCaseItem.pubDate =[pubDate stringValue];
                
                
                GDataXMLElement *duration = [[item elementsForName:@"itunes:duration"] objectAtIndex:0];
                xmlBridCaseItem.duration =[duration stringValue];
                
                
                GDataXMLElement *keywords = [[item elementsForName:@"itunes:keywords"] objectAtIndex:0];
                xmlBridCaseItem.keywords =[keywords stringValue];
                
                
                [array addObject:xmlBridCaseItem];

            }
            
            [dic setObject:array forKey:@"item"];
        }

    return dic;
}
@end
