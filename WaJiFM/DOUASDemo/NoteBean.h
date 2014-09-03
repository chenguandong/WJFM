//
//  NoteBean.h
//  Datastore Examples
//
//  Created by chenguandong on 14-5-22.
//
//

#import <Foundation/Foundation.h>

@interface NoteBean : NSObject
@property int note_ID;
@property(nonatomic,strong)NSString *note_title;
@property(nonatomic,strong)NSString *note_content;
@property(nonatomic,strong)NSString *note_adress;
@property(nonatomic,strong)NSString *note_weather;
@property float note_lat;
@property float note_lng;
@property(nonatomic,strong)NSDate *note_time;

@end
