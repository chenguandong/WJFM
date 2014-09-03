//
//  SqlTools.m
//  Datastore Examples
//
//  Created by chenguandong on 14-5-22.
//
//

#import "SqlTools.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "XMLBrodCastItem.h"
#import "MusicMenuBean.h"
const static NSString *DOWNLOAD_DB_NAME = @"download.db";
const static NSString *FAVOURITE_DB_NAME = @"favourite.db";
const static NSString *FAVOURITE_ALBUM_DB_NAME=@"favourite_album.db";
const static NSString *HISTORY_DB_NAME = @"history.db";
@implementation SqlTools

+(void)getFMdatabase:(NSString*)sql :(FMDatabase*)fmDataBase{
    
    NSLog(@"开始穿件表");
  

   // NSFileManager * fileManager = [NSFileManager defaultManager];
    //if ([fileManager fileExistsAtPath:[self getdbPath]] == NO) {
        // create it
        FMDatabase * db = fmDataBase;
        if ([db open]) {
            
            BOOL res = [db executeUpdate:sql];
            if (!res) {
                NSLog(@"error when creating db table");
            } else {
                NSLog(@"succ to creating db table");
            }
            [db close];
        } else {
            NSLog(@"error when open db");
        }
    }
/**
 download db path
 */
+(FMDatabase*)getDownloadDBPath{
    NSString *_docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *_dbPath = [_docPath stringByAppendingPathComponent:@"download.db"];
    return  [FMDatabase databaseWithPath:_dbPath];
}

/**
 favourite db path
 */
+(FMDatabase*)getFavouriteDBPath{
    NSString *_docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *_dbPath = [_docPath stringByAppendingPathComponent:FAVOURITE_DB_NAME];
    return  [FMDatabase databaseWithPath:_dbPath];
}

/**
 history db path
 */
+(FMDatabase*)getHistoryDBPath{
    NSString *_docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *_dbPath = [_docPath stringByAppendingPathComponent:HISTORY_DB_NAME];
    return  [FMDatabase databaseWithPath:_dbPath];
}

/**
 album db path
 */
+(FMDatabase*)getAlbumFavouriteDBPath{
    NSString *_docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *_dbPath = [_docPath stringByAppendingPathComponent:FAVOURITE_ALBUM_DB_NAME];
    return  [FMDatabase databaseWithPath:_dbPath];
}

+(NSString*)getFavouriteAlbumDBSQL{
    /**
     
     @property(nonatomic,copy)NSString * title;
     @property(nonatomic,copy)NSString * image;
     @property(nonatomic,copy)NSString * description;
     @property(nonatomic,copy)NSString * link;
     @property(nonatomic,copy)NSString * copyright;
     @property(nonatomic,copy)NSString *keywords;
     */
    
    return @"CREATE TABLE IF NOT EXISTS favourite_album (id INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , title text,image text,description text,link text,copyright text,keywords text)";
}

+(NSString*)getDownloadDBSQL{

    return @"CREATE TABLE IF NOT EXISTS download (id INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , title text,author text,subtitle text,summary text,image text,guid text,pubDate text,duration text,keywords text,download_type integer,download_file_name text,album text,file_type integer)";
}

+(NSString*)getFavouriteDBSQL{

    
    return @"CREATE TABLE IF NOT EXISTS favourite (id INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , title text,author text,subtitle text,summary text,image text,guid text,pubDate text,duration text,keywords text,download_type integer,download_file_name text,album text,file_type integer,isfavourite integer)";
}


+(NSString*)getHistoryDBSQL{
    
    
    return @"CREATE TABLE IF NOT EXISTS history (id INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , title text,author text,subtitle text,summary text,image text,guid text,pubDate text,duration text,keywords text,download_type integer,download_file_name text,album text,file_type integer,last_time integer)";
}




/**
 
 查询下载表的全部内容
 */
+(NSArray*)queryData:(NSString*)sql{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];

    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getdbPath:DOWNLOAD_DB_NAME]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        
        FMResultSet *rs = [db executeQuery:sql];//desc asc
        while ([rs next]) {
            
            XMLBrodCastItem *noteBean = [[XMLBrodCastItem alloc] init];
            noteBean.ID = [rs intForColumnIndex:0];
            noteBean.title = [rs stringForColumnIndex:1];
            noteBean.author = [rs stringForColumnIndex:2];
            noteBean.subtitle = [rs stringForColumnIndex:3];
            noteBean.summary = [rs stringForColumnIndex:4];
            noteBean.image =[rs stringForColumnIndex:5];
            noteBean.guid = [rs stringForColumnIndex:6];
            noteBean.pubDate = [rs stringForColumnIndex:7];
            noteBean.duration = [rs stringForColumnIndex:8];
            noteBean.keywords = [rs stringForColumnIndex:9];
            noteBean.download_type = [rs intForColumnIndex:10];
            noteBean.download_file_name = [rs stringForColumnIndex:11];
            noteBean.album  =[rs stringForColumnIndex:12];
            noteBean.file_type = [rs intForColumnIndex:13];
            [array addObject:noteBean];
        }
        [db close];
    }];
    
    
    NSLog(@"count=%d",array.count);
    return array;
}


#pragma mark 查询收藏数据
+(NSArray*)queryFavouriteDB:(NSString*)sql{

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getdbPath:FAVOURITE_DB_NAME]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        
        FMResultSet *rs = [db executeQuery:sql];//desc asc
        while ([rs next]) {
            
            XMLBrodCastItem *noteBean = [[XMLBrodCastItem alloc] init];
            noteBean.ID = [rs intForColumnIndex:0];
            noteBean.title = [rs stringForColumnIndex:1];
            noteBean.author = [rs stringForColumnIndex:2];
            noteBean.subtitle = [rs stringForColumnIndex:3];
            noteBean.summary = [rs stringForColumnIndex:4];
            noteBean.image =[rs stringForColumnIndex:5];
            noteBean.guid = [rs stringForColumnIndex:6];
            noteBean.pubDate = [rs stringForColumnIndex:7];
            noteBean.duration = [rs stringForColumnIndex:8];
            noteBean.keywords = [rs stringForColumnIndex:9];
            noteBean.download_type = [rs intForColumnIndex:10];
            noteBean.download_file_name = [rs stringForColumnIndex:11];
            noteBean.album  =[rs stringForColumnIndex:12];
            noteBean.file_type = [rs intForColumnIndex:13];
            noteBean.isfavourite  = [rs intForColumnIndex:14];
            [array addObject:noteBean];
        }
        [db close];
    }];
    
    
    NSLog(@"count=%d",array.count);
    return array;


}


#pragma mark 查询收藏数据
+(NSArray*)queryHistoryDB:(NSString*)sql{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getdbPath:HISTORY_DB_NAME]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        
        FMResultSet *rs = [db executeQuery:sql];//desc asc
        while ([rs next]) {
            
            XMLBrodCastItem *noteBean = [[XMLBrodCastItem alloc] init];
            noteBean.ID = [rs intForColumnIndex:0];
            noteBean.title = [rs stringForColumnIndex:1];
            noteBean.author = [rs stringForColumnIndex:2];
            noteBean.subtitle = [rs stringForColumnIndex:3];
            noteBean.summary = [rs stringForColumnIndex:4];
            noteBean.image =[rs stringForColumnIndex:5];
            noteBean.guid = [rs stringForColumnIndex:6];
            noteBean.pubDate = [rs stringForColumnIndex:7];
            noteBean.duration = [rs stringForColumnIndex:8];
            noteBean.keywords = [rs stringForColumnIndex:9];
            noteBean.download_type = [rs intForColumnIndex:10];
            noteBean.download_file_name = [rs stringForColumnIndex:11];
            noteBean.album  =[rs stringForColumnIndex:12];
            noteBean.file_type = [rs intForColumnIndex:13];
            noteBean.isfavourite  = [rs intForColumnIndex:14];
            [array addObject:noteBean];
        }
        [db close];
    }];
    
    
    NSLog(@"count=%d",array.count);
    return array;
    
    
}


#pragma mark - 查询收藏专辑
+(NSArray*)queryFavouriteAlbumDB:(NSString*)sql{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getdbPath:FAVOURITE_ALBUM_DB_NAME]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        
        FMResultSet *rs = [db executeQuery:sql];//desc asc
        while ([rs next]) {
            
            MusicMenuBean *musicBena = [[MusicMenuBean alloc] init];
            musicBena.ID = [rs intForColumnIndex:0];
            musicBena.title = [rs stringForColumnIndex:1];
            musicBena.image =[rs stringForColumnIndex:2];

            musicBena.description =[rs stringForColumnIndex:3];
            musicBena.link =[rs stringForColumnIndex:4];
            musicBena.copyright =[rs stringForColumnIndex:5];
            musicBena.keywords =[rs stringForColumnIndex:6];
            
        
            [array addObject:musicBena];
        }
        [db close];
    }];
    
    
    NSLog(@"count=%d",array.count);
    return array;
    
    
}




/**
 数据库的路径
 */
+(NSString*)getdbPath:(NSString*)dbPath{
    NSString *_docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *_dbPath = [_docPath stringByAppendingPathComponent:dbPath];
    return  _dbPath;
}


#pragma mark  插入数据到收藏
+(BOOL)insertFavouriteDate:(XMLBrodCastItem *)xmlBrodCastItem{
    FMDatabase * db = [self getFavouriteDBPath];
    
    BOOL res = NO;
    if ([db open]) {
        
        NSString * sql = @"insert into favourite values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";

         res = [db executeUpdate:sql,
                    nil,
                    xmlBrodCastItem.title, xmlBrodCastItem.author,xmlBrodCastItem.subtitle,xmlBrodCastItem.summary,xmlBrodCastItem.image,xmlBrodCastItem.guid,xmlBrodCastItem.pubDate,xmlBrodCastItem.duration,xmlBrodCastItem.keywords,
                    [NSString stringWithFormat:@"%d",xmlBrodCastItem.download_type],
                    xmlBrodCastItem.download_file_name,
                    xmlBrodCastItem.album,
                    [NSString stringWithFormat:@"%d",xmlBrodCastItem.file_type],
                    [NSString stringWithFormat:@"%d",xmlBrodCastItem.isfavourite]
                    ];
        
        if (!res) {
            NSLog(@"error to insert data");

        } else {
            NSLog(@"succ to insert data");

        }
        [db close];
    }

    return res;
}







#pragma mark  插入数据到收历史记录
+(BOOL)insertHistoryDate:(XMLBrodCastItem *)xmlBrodCastItem{
    FMDatabase * db = [self getHistoryDBPath];
    
    BOOL res = NO;
    if ([db open]) {
        
        NSString * sql = @"insert into history values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
        
        res = [db executeUpdate:sql,
               nil,
               xmlBrodCastItem.title, xmlBrodCastItem.author,xmlBrodCastItem.subtitle,xmlBrodCastItem.summary,xmlBrodCastItem.image,xmlBrodCastItem.guid,xmlBrodCastItem.pubDate,xmlBrodCastItem.duration,xmlBrodCastItem.keywords,
               [NSString stringWithFormat:@"%d",xmlBrodCastItem.download_type],
               xmlBrodCastItem.download_file_name,
               xmlBrodCastItem.album,
               [NSString stringWithFormat:@"%d",xmlBrodCastItem.file_type],
               [NSString stringWithFormat:@"%d",xmlBrodCastItem.isfavourite]
               ];
        
        if (!res) {
            NSLog(@"error to insert data");
            
        } else {
            NSLog(@"succ to insert data");
            
        }
        [db close];
    }
    
    return res;
}



#pragma mark  插入下载数据
+(BOOL)insertDownloadDate:(XMLBrodCastItem *)xmlBrodCastItem{

    FMDatabase * db = [self getDownloadDBPath];
    BOOL res  = NO;
    if ([db open]) {
        
        NSString * sql = @"insert into download values(?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
        
         res = [db executeUpdate:sql,
                        nil,
                        xmlBrodCastItem.title, xmlBrodCastItem.author,xmlBrodCastItem.subtitle,xmlBrodCastItem.summary,xmlBrodCastItem.image,xmlBrodCastItem.guid,xmlBrodCastItem.pubDate,xmlBrodCastItem.duration,xmlBrodCastItem.keywords,
                            [NSString stringWithFormat:@"%d",xmlBrodCastItem.download_type],
                            xmlBrodCastItem.download_file_name,
                            xmlBrodCastItem.album,
                            [NSString stringWithFormat:@"%d",xmlBrodCastItem.file_type]
                    
                    ];
        
        if (!res) {
            NSLog(@"error to insert data");

        } else {
            NSLog(@"succ to insert data");

        }
        [db close];
    }

    return res;
}


+(BOOL)insertDownloadTypeAndFileName:(XMLBrodCastItem *)xmlBrodCastItem{

    // 开始插入
    
    BOOL res = NO;
    
    FMDatabase * db = [self getDownloadDBPath];
    if ([db open]) {
        
        NSString *sql= @"UPDATE  download SET download_type = ?,download_file_name =? where id =?";//
        //NSString * sql = [NSString stringWithFormat:@"insert into download  (download_type,download_file_name)values(?,?)where id ='%d'",xmlBrodCastItem.ID];

         res = [db executeUpdate:sql,
                    [NSString stringWithFormat:@"%d",xmlBrodCastItem.download_type],
                    xmlBrodCastItem.download_file_name,
                    [NSString stringWithFormat:@"%d",xmlBrodCastItem.ID]
                    ];
        
        if (!res) {
            NSLog(@"error to insert data");
        } else {
            NSLog(@"succ to insert data");
        }
        [db close];
    }
    return res;
}

/**
    添加专辑收藏
 */
+(BOOL)insertFavouriteAlbum:(MusicMenuBean *)musicMenuBean{
    
    /**
     
     @property(nonatomic,copy)NSString * title;
     @property(nonatomic,copy)NSString * image;
     @property(nonatomic,copy)NSString * description;
     @property(nonatomic,copy)NSString * link;
     @property(nonatomic,copy)NSString * copyright;
     @property(nonatomic,copy)NSString *keywords;
     */
    
    FMDatabase * db = [self getAlbumFavouriteDBPath];
    BOOL res  = NO;
    if ([db open]) {
        
        NSString * sql = @"insert into favourite_album values(?,?,?,?,?,?,?) ";
        
        res = [db executeUpdate:sql,
               nil,
               musicMenuBean.title,
               musicMenuBean.image,
               musicMenuBean.description,
               musicMenuBean.link,
               musicMenuBean.copyright,
               musicMenuBean.keywords
               
               ];
        
        if (!res) {
            NSLog(@"error to insert data");
            
        } else {
            NSLog(@"succ to insert data");
            
        }
        [db close];
    }
    
    return res;
}





/**
    检查是否已经收藏
 */
+(BOOL)checkIsFavourite:(NSString*)sql{
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getdbPath:FAVOURITE_DB_NAME]];

    BOOL __block ishava = NO;
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {

            if ([rs intForColumnIndex:0]>0) {
                ishava = YES;
            }else{
                ishava = NO;
            }
        }
        
        [db close];
    }];
    return ishava;
}




/**
 检查是否已经收藏专辑
 */
+(BOOL)checkIsFavouriteAlbum:(NSString*)sql{
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getdbPath:FAVOURITE_ALBUM_DB_NAME]];
    
    BOOL __block ishava = NO;
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            
            if ([rs intForColumnIndex:0]>0) {
                ishava = YES;
            }else{
                ishava = NO;
            }
        }
        
        [db close];
    }];
    return ishava;
}


+(BOOL)deleteFavourite:(NSString*)sql{
    BOOL res  = NO;
    FMDatabase * db = [self getFavouriteDBPath];
    if ([db open]) {

         res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error to delete db data");
        } else {
            NSLog(@"succ to deleta db data");
        }
        [db close];
    }
    
    return res;
}

/**
    删除收藏专辑
 */
+(BOOL)deleteFavouriteAlbum:(NSString*)sql{
    BOOL res  = NO;
    FMDatabase * db = [self getAlbumFavouriteDBPath];
    if ([db open]) {
        
        res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error to delete db data");
        } else {
            NSLog(@"succ to deleta db data");
        }
        [db close];
    }
    
    return res;
}
@end
