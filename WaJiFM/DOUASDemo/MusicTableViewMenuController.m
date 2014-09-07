//
//  MusicTableViewMenuController.m
//  DOUASDemo
//
//  Created by chenguandong on 14-6-3.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import "MusicTableViewMenuController.h"
#import "HttpTools.h"
#import "JsonTools.h"
#import "MusicMenuAllBean.h"
#import "ViewDeck/IIViewDeckController.h"
#import "MusicTableViewMenuController.h"
#import "DownLoadTools.h"
@interface MusicTableViewMenuController ()
@property(nonatomic,strong)NSMutableArray *menuArrayData;
@end

@implementation MusicTableViewMenuController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    _menuArrayData =[NSMutableArray arrayWithCapacity:3];
    
    [self getMusicData];
    
    self.title = @"分类列表";
    
    //添加代码
    if (IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;               //视图控制器，四条边不指定
        self.extendedLayoutIncludesOpaqueBars = NO;
        //不透明的操作栏<br>
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
        
        self.navigationController.navigationBar.barTintColor  = Default_Nav_Color;
    }else{
         self.navigationController.navigationBar.tintColor = Default_Nav_Color;
    }


    
    
}



///第一次加载数据  右边栏
-(void)getMusicData{
    
    
    [[HttpTools getAFHTTPRequestOperationManager]POST:MUSIC_HTTP_PATH parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"***************%@",[operation responseString]);
        NSArray *tempArr = [JsonTools getMusicMenuData:[operation responseString]];
        
        NSLog(@"tempArr=%d",tempArr.count);
        
        for (MusicMenuAllBean *bxx in tempArr) {
            NSLog(@"bxx=%d",bxx.subCategory.count);
        }
        
        if (tempArr) {
            [_menuArrayData addObjectsFromArray:tempArr];
        }
       
        
        [self.tableView reloadData];
        
        
        //通知主页更新
        
        if (nil!=_menuArrayData) {
            NSArray *arr =[_menuArrayData[0] subCategory];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"MENU" object:arr];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"##############%@",error);
    }];
    
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
    return [_menuArrayData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //cell.backgroundColor = [UIColor clearColor];
    // Configure the cell...
    cell.backgroundColor = nil;
    
    MusicMenuAllBean *musicAllBean = _menuArrayData[(NSUInteger)indexPath.row];
   
    cell.textLabel.text =musicAllBean.categoryName;
    
    cell.textLabel.textColor = [UIColor whiteColor];

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


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        
        NSArray *arr =[_menuArrayData[(NSUInteger)indexPath.row] subCategory];
        NSLog(@"%d",arr.count);
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MENU" object:arr];
    }];


}


@end
