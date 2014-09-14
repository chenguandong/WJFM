//
//  FavouriteTableViewController.m
//  DOUASDemo
//
//  Created by chenguandong on 14-6-15.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import "FavouriteTableViewController.h"
#import "XMLBrodCastItem.h"
#import "AppDelegate.h"
#import "Track.h"
#import "SqlTools.h"
#import "MusicCell.h"
#import "StringTools.h"
@interface FavouriteTableViewController ()

@end

@implementation FavouriteTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _allData = [NSMutableArray new];
    [self setQuerySql:@"select *from favourite"];
    
    [self startQueryData];
    self.tableView.rowHeight =100;
    
    
}


-(void)setSqlQuery:(NSString*)querySql{

    _querySql = querySql;

}
-(void)startQueryData{
    
     [SVProgressHUD showWithStatus:@"数据加载中..."];
    
    NSLog(@"======%@",_querySql);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        // time-consuming task
        _allData = [SqlTools queryFavouriteDB: _querySql];
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        });
    });
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return _allData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellMusic";
    MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //将Custom.xib中的所有对象载入
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MusicCell" owner:nil options:nil];
        //第一个对象就是CustomCell了
        cell = [nib objectAtIndex:0];
    }
    
    [cell.musicDownloadButton addTarget:self action:@selector(mystartDownload:) forControlEvents:UIControlEventTouchDown];
    
    
    
    // Configure the cell...
    
    XMLBrodCastItem *musicBean = _allData[(NSUInteger)indexPath.row];
    
    
    cell.musicTitle.text =musicBean.title;
    cell.musicSubTitle.text = musicBean.subtitle;
    [cell.musicImg setImageWithURL:[NSURL URLWithString:musicBean.image] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    //检查是否已经收藏
    if ([self checkFavourite:musicBean.title]) {
        //如果应经收藏 取消收藏
        
        
    }
    else{
        //如果没有收藏 添加收藏
        
        [cell.musicLove setImage:[UIImage imageNamed:@"like_enabled"] forState:UIControlStateNormal];
    }
    [cell.musicLove addTarget:self action:@selector(addFavoutite:) forControlEvents:UIControlEventTouchDown];
    
    [cell.musicLove setTag:indexPath.row];
    [cell.musicDownloadButton setTag:indexPath.row];
     cell.backgroundColor = [UIColor clearColor];
    return cell;
    
    
}


#pragma mark 音乐操作
-(BOOL)delectFavourite:(NSString*)title{
    
   return  [SqlTools deleteFavourite:[NSString stringWithFormat:@"delete  from favourite where title = '%@'",title]];
}

-(BOOL)checkFavourite:(NSString*)title{
    
    return [SqlTools checkIsFavourite:[NSString stringWithFormat:@"SELECT COUNT(*) FROM favourite where title='%@'",title]];
}
-(BOOL)insertFavourite:(XMLBrodCastItem*)favouriteBean{
    return [SqlTools insertFavouriteDate:favouriteBean];
}


#pragma mark 收藏音乐
-(void)addFavoutite:(id)sender{
    
    
    
    UIButton *button  = (UIButton*)sender;
    
    
    XMLBrodCastItem *favouriteBean= _allData[(NSUInteger)button.tag];
    
    
    
    //检查是否已经收藏
    if ([self checkFavourite:favouriteBean.title]) {
        //如果应经收藏 删除收藏
        
        BOOL __block isDel= NO;
        // 删除收藏数据
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
            
            // 检查数据库是否创建
            [SqlTools getFMdatabase:[SqlTools getFavouriteDBSQL] :[SqlTools getFavouriteDBPath]];
            
            isDel =[SqlTools deleteFavourite:[NSString stringWithFormat:@"delete  from favourite where title = '%@'",favouriteBean.title]];
            
            dispatch_async(dispatch_get_main_queue(),^{
                
                [SVProgressHUD dismiss];
                if (isDel) {
                    [button setImage:[UIImage imageNamed:@"like_enabled"] forState:UIControlStateNormal];
                }
                
                
            });
        });
        
        
    }
    else{
        //如果没有收藏 添加收藏
        
        // 插入数据
        BOOL __block isInsert = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
            //favouriteBean.album = [_albumInfo.title stringByAppendingFormat:@"%@%@",@"__",_albumInfo.
                               //    image];
            
            favouriteBean.file_type =[StringTools getFileType:favouriteBean.guid];
            
            favouriteBean.isfavourite = 1;
            
            isInsert = [self insertFavourite:favouriteBean];
            
            // 检查数据库是否创建
            [SqlTools getFMdatabase:[SqlTools getFavouriteDBSQL] :[SqlTools getFavouriteDBPath]];
            dispatch_async(dispatch_get_main_queue(),^{        [SVProgressHUD dismiss];
                
                
                if (isInsert) {
                    [button setImage:[UIImage imageNamed:@"ic_player_fav_selected_highlight.png"] forState:UIControlStateNormal];
                }
                
            });
        });
        
    }
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
     XMLBrodCastItem *delBean = _allData[indexPath.row];

     BOOL __block isDel= NO;
     // 删除收藏数据
     
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
         
         // 检查数据库是否创建
         [SqlTools getFMdatabase:[SqlTools getFavouriteDBSQL] :[SqlTools getFavouriteDBPath]];
         
         isDel = [self delectFavourite:delBean.title];
         
         dispatch_async(dispatch_get_main_queue(),^{
             
             [SVProgressHUD dismiss];
             if (isDel) {
                 [_allData removeObject:delBean];
                  [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
             }
             
             
         });
     });

     
     
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */


 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [playerViewController setTitle:@"Local Music Library ♫"];
    //    [playerViewController setTracks:[Track musicLibraryTracks]];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    [appDelegate.playerColl setTitle:@"Remote Music ♫"];
    
    
    
    NSMutableArray *arr = [NSMutableArray new];
    
    for ( XMLBrodCastItem *musicBean in _allData) {
        Track *track = [[Track alloc]init];
        track.artist = musicBean.author;
        track.title = musicBean.title;
        track.audioFileURL =[NSURL URLWithString:musicBean.guid];
        track.audioImg = musicBean.image;
        track.subTitle = musicBean.subtitle;
        [arr addObject:track];
        
    }
    
    [appDelegate.playerColl setTracks:arr] ;
    
    //[appDelegate.playerColl setTracks:arr];
    
    appDelegate.playerColl.currentTrackIndex = (NSUInteger)indexPath.row;
    
    [[self navigationController] pushViewController:appDelegate.playerColl
                                           animated:YES];
}




@end
