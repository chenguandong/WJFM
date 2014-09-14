//
//  BaseTableViewController.m
//  WJFM
//
//  Created by chen.gd on 14-9-2.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UIImageView+LBBlurredImage.h"
@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //去除多余分割线
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    
   
    self.tableView.backgroundColor = [UIColor clearColor];
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:kBackgroundImageName]];
    
    [bgImageView setImageToBlur:bgImageView.image blurRadius:0.01 completionBlock:^{
        self.tableView.backgroundView = bgImageView;
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
