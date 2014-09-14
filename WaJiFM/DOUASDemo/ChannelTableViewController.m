//
//  ChannelTableViewController.m
//  DOUASDemo
//
//  Created by chenguandong on 14-6-4.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import "ChannelTableViewController.h"
#import "XMLTools.h"
#import "XMLBrodCastItem.h"
#import "PlayerViewController.h"
#import "Track+Provider.h"
#import "Track.h"
#import "AppDelegate.h"
#import "TCBlobDownload.h"
#import "SqlTools.h"
#import "DownLoadTools.h"
#import "DownloadTableViewController.h"
#import "StringTools.h"
#import "MusicCell.h"
#import "SqlTools.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MyMPMoviePlayerViewController.h"
#import "MJRefresh.h"
#import "UIImageView+LBBlurredImage.h"

#define kDownloadPath [NSString pathWithComponents:@[NSTemporaryDirectory(), @"multipleExample"]]
const int kPageSize = 10;
@interface ChannelTableViewController ()

{
    int pageCount;
    int pageCountNow ;

    BOOL isFistLoad ;
    
}

@end

@implementation ChannelTableViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    isFistLoad = YES;
 
  
    
    _channelArray  = [NSMutableArray arrayWithCapacity:10];
    _allChannelArray =[NSArray array];
    
    
  
    
    [self loadDate];
    [self initHeadView];
    self.tableView.rowHeight = 100;
    
    [self.tableView addHeaderWithCallback:^{
       self.loadMoreText.text = @"上拉加载更多";
        
        [self.tableView reloadData];
        
        [self loadDate];

        
         [self.tableView setFooterHidden:NO];
    }];
    
    [self.tableView addFooterWithCallback:^{
        
        if (pageCountNow<pageCount) {
            [self getMoreData];
        }else{
            NSLog(@"数据加载完了...");
            [self.tableView footerEndRefreshing];
          
            [self.tableView setFooterHidden:YES];
             _loadMoreView.hidden = NO;
            
            _loadMoreText.text = @"没有更多数据了";
            
        }
        
    }];
    

   
    
}

#pragma mark 收藏专辑
- (IBAction)albumLove:(id)sender {
    
    //检查数据库是都创建
    [SqlTools getFMdatabase:[SqlTools getFavouriteAlbumDBSQL] :[SqlTools getAlbumFavouriteDBPath]];

    //检查是否已经收藏
    if ([SqlTools checkIsFavouriteAlbum:[NSString stringWithFormat:@"SELECT COUNT(*) FROM favourite_album where title='%@'",_albumInfo.title]]) {
        //如果应经收藏 删除收藏
        
        BOOL __block isDel= NO;
        // 删除收藏数据
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
            
           
            
            isDel = [SqlTools deleteFavouriteAlbum:[NSString stringWithFormat:@"delete  from favourite_album where title = '%@'",_albumInfo.title]];
            
            dispatch_async(dispatch_get_main_queue(),^{
                

                if (isDel) {
                    [_headLoveButton setImage:[UIImage imageNamed:@"like_enabled"] forState:UIControlStateNormal];
                }
                
                
            });
        });
        
        
    }
    else{
        //如果没有收藏 添加收藏
        
        // 插入数据
        BOOL __block isInsert = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
           
            
            isInsert = [SqlTools insertFavouriteAlbum:_albumInfo];
            
            
            dispatch_async(dispatch_get_main_queue(),^{
                
                if (isInsert) {
                    [_headLoveButton setImage:[UIImage imageNamed:@"ic_player_fav_selected_highlight.png"] forState:UIControlStateNormal];
                }
                
            });
        });
        
    }
    
    
    

}
- (IBAction)albumDownload:(id)sender {
}

-(void)initHeadView{
  
    
    [self.headImg setImageWithURL:[NSURL URLWithString:_albumInfo.image] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        if (error==nil) {
            [_headBgView setImageToBlur:self.headImg.image blurRadius:0.1 completionBlock:^{
            }];
        }else{
            [_headBgView setImageToBlur:[UIImage imageNamed:@"Default"] completionBlock:^{
                
            }];
        }
    }];
    
    
    
    
  
    
   // self.headTitle.text  = _albumInfo.title;
   // self.headTitle.backgroundColor = [UIColor clearColor];
    self.title =_albumInfo.title;

}

-(void)loadDate{

    if (isFistLoad) {
         [SVProgressHUD showWithStatus:@"数据加载中..."];
        isFistLoad = NO;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        // time-consuming task
        NSDictionary *dic = [XMLTools getBrodCastXML:_albumInfo.link];
        _allChannelArray = [dic objectForKey:@"item"];
        dispatch_async(dispatch_get_main_queue(),^{
            [SVProgressHUD dismiss];
            if (_allChannelArray.count>0) {
                if (_allChannelArray.count%kPageSize==0) {
                    pageCount =_allChannelArray.count/kPageSize;
                }else{
                
                    if (_allChannelArray.count<10) {
                        pageCount = 1;
                    }else{
                        pageCount =_allChannelArray.count/kPageSize+1;
                    }
                }
                
                NSLog(@"总条数:%d",_allChannelArray.count);
                NSLog(@"总页数:%d",pageCount);

            }
            if (_allChannelArray.count>0) {
                pageCountNow = 0;
                
                [self.channelArray removeAllObjects];
                [self getMoreData];
                [self.tableView headerEndRefreshing];
                [self.tableView setTableFooterView:_loadMoreView];
                _loadMoreText.text = @"上拉加载更多";
            }
        });
    });
}

-(void)getMoreData{
     pageCountNow++;
    NSLog(@"当前页码数:%d",pageCountNow);
    for (int i  =((pageCountNow-1)*10); i<(pageCountNow*kPageSize>_allChannelArray.count?_allChannelArray.count:pageCountNow*kPageSize); i++) {
        NSLog(@"i===%d",i);
        [_channelArray addObject:_allChannelArray[i]];
    }
  
    [self.tableView reloadData];
    
    [self.tableView footerEndRefreshing];
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
    return _channelArray.count;
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
    
    XMLBrodCastItem *musicBean = _channelArray[(NSUInteger)indexPath.row];
   
    
    cell.musicTitle.text =musicBean.title;
    cell.musicSubTitle.text = musicBean.subtitle;
    [cell.musicImg setImageWithURL:[NSURL URLWithString:musicBean.image] placeholderImage:[UIImage imageNamed:@"placeholder"]];
   
    //检查是否已经收藏
    if ([SqlTools checkIsFavourite:[NSString stringWithFormat:@"SELECT COUNT(*) FROM favourite where title='%@'",musicBean.title]]) {
        //如果应经收藏 取消收藏
        

    }
    else{
        //如果没有收藏 添加收藏
  
     [cell.musicLove setImage:[UIImage imageNamed:@"like_enabled"] forState:UIControlStateNormal];
    }
    [cell.musicLove addTarget:self action:@selector(addFavoutite:) forControlEvents:UIControlEventTouchDown];
    
    [cell.musicLove setTag:indexPath.row];
    [cell.musicDownloadButton setTag:indexPath.row];
    
    cell.alpha = 0.5;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


#pragma mark 收藏音乐
-(void)addFavoutite:(id)sender{


    
    UIButton *button  = (UIButton*)sender;
   
    
   XMLBrodCastItem *favouriteBean= _channelArray[(NSUInteger)button.tag];


    
    //检查是否已经收藏
    if ([SqlTools checkIsFavourite:[NSString stringWithFormat:@"SELECT COUNT(*) FROM favourite where title='%@'",favouriteBean.title]]) {
        //如果应经收藏 删除收藏

        BOOL __block isDel= NO;
        // 删除收藏数据
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
            
            // 检查数据库是否创建
            [SqlTools getFMdatabase:[SqlTools getFavouriteDBSQL] :[SqlTools getFavouriteDBPath]];
            
            isDel = [SqlTools deleteFavourite:[NSString stringWithFormat:@"delete  from favourite where title = '%@'",favouriteBean.title]];
            
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
            favouriteBean.album = [_albumInfo.title stringByAppendingFormat:@"%@%@",@"__",_albumInfo.
                                   image];
            
            favouriteBean.file_type =[StringTools getFileType:favouriteBean.guid];
            
            favouriteBean.isfavourite = 1;
            
            isInsert = [SqlTools insertFavouriteDate:favouriteBean];
            
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    //    [playerViewController setTitle:@"Local Music Library ♫"];
    //    [playerViewController setTracks:[Track musicLibraryTracks]];
    
    XMLBrodCastItem *tempBean =_channelArray[indexPath.row];

    NSLog(@"fileTypr=%d",tempBean.file_type);
    
    if ([StringTools getFileType:tempBean.guid]==1) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        [appDelegate.playerColl setTitle:@"Remote Music ♫"];
        
        NSMutableArray *arr = [NSMutableArray new];
        for ( XMLBrodCastItem *musicBean in _channelArray) {
            Track *track = [[Track alloc]init];
            track.artist = musicBean.author;
            track.title = musicBean.title;
            track.audioFileURL =[NSURL URLWithString:musicBean.guid];
            track.audioImg = musicBean.image;
            track.subTitle = musicBean.subtitle;
            [arr addObject:track];
            
        }
        
        [appDelegate.playerColl setTracks:arr];
        
        appDelegate.playerColl.currentTrackIndex = (NSUInteger)indexPath.row;
        
        appDelegate.playerColl.musicDetail =_channelArray;
        
        [[self navigationController] pushViewController:appDelegate.playerColl
                                               animated:YES];
    }else{
        NSLog(@"------%@",tempBean.guid);

        //[NSURL URLWithString:tempBean.guid]
        
        
        
        MyMPMoviePlayerViewController *movieColl = [[MyMPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:tempBean.guid]];
        movieColl.moviePlayer.allowsAirPlay = YES;

        [self presentMoviePlayerViewControllerAnimated:movieColl];
        
       

    }
    
}

#pragma mark 点击下载按钮
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{


}


-(void)mystartDownload:(id)sender{

    UIButton *downloadButton = (UIButton*)sender;
    
    
    //检查数据库是否创建
    
    [SqlTools getFMdatabase:[SqlTools getDownloadDBSQL] :[SqlTools getDownloadDBPath]];
    
    [[TCBlobDownloadManager sharedInstance]cancelAllDownloadsAndRemoveFiles:NO];
    
    
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        // time-consuming task
        //  插入下载的数据到下载表中
        XMLBrodCastItem *item = _channelArray[(NSUInteger)downloadButton.tag];
        item.album = [_albumInfo.title stringByAppendingFormat:@"%@%@",@"__",_albumInfo.
                      image];
        NSLog(@"album=%@",item.album);
        
        item.file_type =[StringTools getFileType:item.guid];
        
        [SqlTools insertDownloadDate:item];
        
        dispatch_async(dispatch_get_main_queue(),^{        [SVProgressHUD dismiss];
            //重新开始现在任务
            
            [[DownloadTableViewController sharedController]startDownLoad];
            
        });
    });

}



@end
