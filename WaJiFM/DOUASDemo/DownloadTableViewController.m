//
//  DownloadTableViewController.m
//  DOUASDemo
//
//  Created by chenguandong on 14-6-7.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import "DownloadTableViewController.h"
#import "DownLoadTools.h"
#import "DownLoadTableViewCell.h"
#import "XMLBrodCastItem.h"
#import "SqlTools.h"
#import "DownloadTableViewController.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "DownLoadedViewController.h"
@interface DownloadTableViewController ()

@end

@implementation DownloadTableViewController
static DownloadTableViewController *sharedRootController = nil;


+(DownloadTableViewController *) sharedController{
    @synchronized(self)
    {
        if (sharedRootController == nil)
        {
            sharedRootController = [[self alloc] init];
        }
    }
    return sharedRootController;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    
    _allDownLoadData = [NSMutableArray new];
    
    [self startDownLoad];

    self.tableView.rowHeight =80;
}


-(void)startDownLoad{
    
    NSLog(@"增加了下载队列");
     [SVProgressHUD showWithStatus:@"数据加载中..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        // time-consuming task
        _allDownLoadData = [SqlTools queryData:@"select * from download where download_type <3 "];

        
        dispatch_async(dispatch_get_main_queue(),^{

            
            
            for (XMLBrodCastItem *bean in _allDownLoadData) {
                TCBlobDownloader *download = [[TCBlobDownloader alloc] initWithURL:[NSURL URLWithString:bean.guid] downloadPath:kDownloadPath delegate:self];

               [[TCBlobDownloadManager sharedInstance] startDownload:download];

            }
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
    return _allDownLoadData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Download";
    DownLoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //将Custom.xib中的所有对象载入
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DownLoadTableViewCell" owner:nil options:nil];
        //第一个对象就是CustomCell了
        cell = [nib objectAtIndex:0];
    }
    
    XMLBrodCastItem *item =_allDownLoadData[(NSUInteger)indexPath.row];
    
    cell.sdTitle.text =item.title ;
    [cell.imageView setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:[UIImage imageNamed:@"placeholder"]];
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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/




#pragma mark - TCBlobDownloader Delegate
/**

- (void)download:(TCBlobDownloader *)blobDownload didFinishWithSuccess:(BOOL)downloadFinished atPath:(NSString *)pathToFile
{
    NSLog(@"FINISHED");
    NSInteger index = [self.currentDownloads indexOfObject:blobDownload];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index
                                                                                     inSection:0]];
    [cell.detailTextLabel setText:[self subtitleForDownload:blobDownload]];
}

- (void)download:(TCBlobDownloader *)blobDownload
  didReceiveData:(uint64_t)receivedLength
         onTotal:(uint64_t)totalLength
        progress:(float)progress
{
    NSInteger index = [self.currentDownloads indexOfObject:blobDownload];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index
                                                                                     inSection:0]];
    [cell.detailTextLabel setText:[self subtitleForDownload:blobDownload]];
}

- (void)download:(TCBlobDownloader *)blobDownload didReceiveFirstResponse:(NSURLResponse *)response
{
    NSInteger index = [self.currentDownloads indexOfObject:blobDownload];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index
                                                                                     inSection:0]];
    [cell.detailTextLabel setText:[self subtitleForDownload:blobDownload]];
}

- (void)download:(TCBlobDownloader *)blobDownload didStopWithError:(NSError *)error
{
    NSInteger index = [self.currentDownloads indexOfObject:blobDownload];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index
                                                                                     inSection:0]];
    [cell.detailTextLabel setText:[self subtitleForDownload:blobDownload]];
}
 */


- (NSString *)subtitleForDownload:(TCBlobDownloader *)download :(NSInteger*)index
{
    NSString *stateString;
    
    switch (download.state) {
        case TCBlobDownloadStateReady:
            stateString = @"Ready";
            break;
        case TCBlobDownloadStateDownloading:
            stateString = @"Downloading";
            break;
        case TCBlobDownloadStateDone:
            stateString = @"Done";

            break;
            
        case TCBlobDownloadStateCancelled:
            stateString = @"Cancelled";
            break;
        case TCBlobDownloadStateFailed:
            stateString = @"Failed";
            break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%i%% • %lis left • State: %@",
            (int)(download.progress * 100),
            (long)download.remainingTime,
            stateString];
}


-(void)setDownLoadState:(TCBlobDownloader*)blobDownload{
    
 
    NSInteger index;
    XMLBrodCastItem *xmlBean;

    for (XMLBrodCastItem *bbean in _allDownLoadData) {
        if ([bbean.guid hasSuffix:blobDownload.fileName]) {
            index = [_allDownLoadData indexOfObject:bbean];
            xmlBean = bbean;
            break;
        };
    }
  
    DownLoadTableViewCell *cell = (DownLoadTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index   inSection:0]];
   
    cell.sdSubTitle.text =[self subtitleForDownload:blobDownload :&index];
 
    cell.sdProgress.progress = blobDownload.progress;

    if (blobDownload.state==TCBlobDownloadStateDone) {
        XMLBrodCastItem *insetBean  = _allDownLoadData[(NSUInteger)index];
        insetBean.download_file_name = blobDownload.pathToFile;
        insetBean.download_type= 3;
        [SqlTools insertDownloadTypeAndFileName:insetBean];
        
        //下载完毕的界面刷新
        [[DownLoadedViewController sharedController]startQueryData];
        //本页面刷新
        [[TCBlobDownloadManager sharedInstance]cancelAllDownloadsAndRemoveFiles:NO];
        [_allDownLoadData removeObject:xmlBean];
        [self startDownLoad];
    }

}

#pragma mark - TCBlobDownloader Delegate


- (void)download:(TCBlobDownloader *)blobDownload didFinishWithSuccess:(BOOL)downloadFinished atPath:(NSString *)pathToFile
{
    NSLog(@"FINISHED");

    [self setDownLoadState:blobDownload];
}

- (void)download:(TCBlobDownloader *)blobDownload
  didReceiveData:(uint64_t)receivedLength
         onTotal:(uint64_t)totalLength
        progress:(float)progress
{

     [self setDownLoadState:blobDownload];
}

- (void)download:(TCBlobDownloader *)blobDownload didReceiveFirstResponse:(NSURLResponse *)response
{
   
    
     [self setDownLoadState:blobDownload];
}

- (void)download:(TCBlobDownloader *)blobDownload didStopWithError:(NSError *)error
{


     [self setDownLoadState:blobDownload];
}
@end
