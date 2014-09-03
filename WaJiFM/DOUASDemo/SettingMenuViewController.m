//
//  SettingMenuViewController.m
//  DOUASDemo
//
//  Created by chenguandong on 14-6-13.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import "SettingMenuViewController.h"
#import "SettingTableViewCell.h"
#import "SettingBean.h"
#import "DownLoadViewController.h"
#import "FavouriteViewController.h"
#import "HistoryTableViewController.h"
#import "HistoryTableViewController.h"
#import "ViewHelperTools.h"
@interface SettingMenuViewController ()

@end

@implementation SettingMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _arr = [NSMutableArray new];
    
    [self initSetting];
    
    //隐藏多余的分割线
     [ViewHelperTools hiddenTableSeparator:self.tableView];
}

-(void)initSetting{
    SettingBean *bean1 = [SettingBean new];
    bean1.setttingImg = @"paly_btn_next.png";
    bean1.settingName = @"下载";
    
    [_arr addObject:bean1];
    
    
    SettingBean *bean2 = [SettingBean new];
    bean2.setttingImg = @"paly_btn_next.png";
    bean2.settingName = @"收藏";
    [_arr addObject:bean2];
    
    SettingBean *bean3 = [SettingBean new];
    bean3.setttingImg = @"paly_btn_next.png";
    bean3.settingName = @"历史记录";
    [_arr addObject:bean3];
}

-(void)junmpDownload{
   
    
    NSLog(@"1111");
    DownLoadViewController *downLoadColl = [DownLoadViewController sharedController];
    
    [self.navigationController pushViewController:downLoadColl animated:YES];
}

#pragma mark 跳转到历史记录
-(void)jumpHistory{
    HistoryTableViewController *historyColl = [HistoryTableViewController new];
    
    [self.navigationController pushViewController:historyColl animated:YES];
}

-(void)jumpFavourite{
    FavouriteViewController *faouriteColl = [FavouriteViewController new];
    [self.navigationController pushViewController:faouriteColl animated:YES];
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
    return (int)_arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellSets";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    // Configure the cell...
    SettingBean *bean = _arr[(NSUInteger)indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:bean.setttingImg];
    cell.textLabel.text =bean.settingName;
    
    
    return cell;
}


// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"xxxx%d",indexPath.row);
    switch (indexPath.row) {
        case 0:
            [self junmpDownload];
            break;
        case 1:
            [self jumpFavourite];
            break;
        case 2:
            [self jumpHistory];
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
