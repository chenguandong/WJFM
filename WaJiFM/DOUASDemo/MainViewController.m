/* vim: set ft=objc fenc=utf-8 sw=2 ts=2 et: */
/*
 *  DOUAudioStreamer - A Core Audio based streaming audio player for iOS/Mac:
 *
 *      https://github.com/douban/DOUAudioStreamer
 *
 *  Copyright 2013-2014 Douban Inc.  All rights reserved.
 *
 *  Use and distribution licensed under the BSD license.  See
 *  the LICENSE file for full text.
 *
 *  Authors:
 *      Chongyu Zhu <i@lembacon.com>
 *
 */

#import "MainViewController.h"
#import "PlayerViewController.h"
#import "Track+Provider.h"
#import "MusicMenuBean.h"
#import "ChannelTableViewController.h"
#import "AppDelegate.h"
#import "IIViewDeckController.h"
#import "DownloadTableViewController.h"
#import "DownloadTableViewController.h"
#import "DownLoadViewController.h"
#import "MusicPlayViewController.h"
#import "PlayerViewController.h"
#import "AlbumCellTableViewCell.h"
#import "SettingMenuViewController.h"
#import "ViewHelperTools.h"
#import "UIImageView+LBBlurredImage.h"
@implementation MainViewController

- (void)viewDidLoad
{
    [self setTitle:@"频道列表 ♫"];
    

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    //[self.view addSubview:_tableView];
    
    self.tableView.rowHeight = 100;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NOTICOME:) name:@"MENU" object:nil];
    

    
    
    UIBarButtonItem *rightBarButton= [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(jumpSetting)];
    
    

    
    UIBarButtonItem *lefuBarButton = [[UIBarButtonItem alloc]initWithTitle:@"频道列表"  style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
    
    self.navigationItem.leftBarButtonItem= lefuBarButton;
   
    self.navigationItem.rightBarButtonItem = rightBarButton;

    
    MusicPlayViewController *musicColl = [MusicPlayViewController sharedController];
   
    [_musicView addSubview:musicColl.view];

    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    
    tapGr.cancelsTouchesInView = YES;
    
    [musicColl.view addGestureRecognizer:tapGr];


    

    //

    [ViewHelperTools hiddenTableSeparator:self.tableView];
    
    
    [self setBaseTableView];
}

#pragma mark  设置table的属性
-(void)setBaseTableView{

    UIView *view = [UIView new];
    view.backgroundColor = [UIColor orangeColor];
    [self.tableView setTableFooterView:view];
    
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:kBackgroundImageName]];
    
    [bgImageView setImageToBlur:bgImageView.image completionBlock:^{
        self.tableView.backgroundView = bgImageView;
    }];
    
   
}


-(void)jumpSetting{

    
    SettingMenuViewController *settingMenuColl= [SettingMenuViewController new];
    
    [self.navigationController pushViewController:settingMenuColl animated:YES];
    

}


-(void)viewTapped:(UITapGestureRecognizer*)tapGr

{
    NSLog(@"**************");
    PlayerViewController *playColl =[[PlayerViewController sharedController]init];
     playColl.currentTrackIndex = (NSUInteger)-1;
    [self.navigationController pushViewController:playColl animated:YES];

}


-(void)showMenu{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    [appDelegate.deckController toggleLeftView];
    

}


-(void)NOTICOME:(NSNotification*)notification{
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    _array = [notification object];

    [self.tableView reloadData];
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return (int)_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellAlbum";
    AlbumCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //将Custom.xib中的所有对象载入
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AlbumCellTableViewCell" owner:nil options:nil];
        //第一个对象就是CustomCell了
        cell = [nib objectAtIndex:0];
    }
    

    
    if (_array) {
        MusicMenuBean *bean = _array[(NSUInteger)indexPath.row];
        cell.albumTitle.text = bean.title;
        cell.albumSubTitle.text = bean.description;
        [cell.albumImgView setImageWithURL:[NSURL URLWithString:bean.image]
                       placeholderImage:[UIImage imageNamed:@"mplaceholder"]];
     
    }
    cell.backgroundColor = [UIColor clearColor];
    
    [cell setSelectedBackgroundView:nil];
    
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ChannelTableViewController *channelColl = [[ChannelTableViewController alloc]init];
    
    channelColl.albumInfo = _array[(NSUInteger)indexPath.row] ;
    
    [self.navigationController pushViewController:channelColl animated:YES];
}



@end
