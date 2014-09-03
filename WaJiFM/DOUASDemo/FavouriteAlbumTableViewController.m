//
//  FavouriteAlbumTableViewController.m
//  DOUASDemo
//
//  Created by chenguandong on 14-6-15.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import "FavouriteAlbumTableViewController.h"
#import "SqlTools.h"
#import "MusicMenuBean.h"
#import "ChannelTableViewController.h"
@interface FavouriteAlbumTableViewController ()

@end

@implementation FavouriteAlbumTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _favouriteAlbums = [NSMutableArray new];
    
    [self startQueryData];
    self.tableView.rowHeight =80;
    

}


-(void)startQueryData{
    
    
     [SVProgressHUD showWithStatus:@"数据加载中..."];
    
    [SqlTools getFMdatabase:[SqlTools getFavouriteAlbumDBSQL] :[SqlTools getAlbumFavouriteDBPath]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        // time-consuming task
        _favouriteAlbums = [SqlTools queryFavouriteAlbumDB: @"select * from favourite_album"];
        
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
    return (int)_favouriteAlbums.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"favouiteAlbum";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    // Configure the cell...
    
    MusicMenuBean *musicMenuBean =_favouriteAlbums[(NSUInteger)indexPath.row];
    
    cell.textLabel.text =musicMenuBean.title ;
    cell.detailTextLabel.text= musicMenuBean.description;
    [cell.imageView setImageWithURL:[NSURL URLWithString:musicMenuBean.image] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    return cell;
    
    
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
     
     
     NSLog(@"************");
     
     BOOL __block isDel= NO;
     // 删除收藏数据
     
     MusicMenuBean *delBean  = _favouriteAlbums[(NSUInteger)indexPath.row];
     
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
         
         
         
         isDel = [SqlTools deleteFavouriteAlbum:[NSString stringWithFormat:@"delete  from favourite_album where title = '%@'",delBean.title]];
         
         dispatch_async(dispatch_get_main_queue(),^{
             
             
             if (isDel) {
                 
                 
                 [_favouriteAlbums removeObject:delBean];
                 
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
    
    ChannelTableViewController *channelColl = [ChannelTableViewController new];
    
    channelColl.albumInfo = _favouriteAlbums[(NSUInteger)indexPath.row] ;
    
    [self.navigationController pushViewController:channelColl animated:YES];
    
}


@end
