//
//  BaseViewController.m
//  WJFM
//
//  Created by chen.gd on 14-9-2.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

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
    // Do any additional setup after loading the view.
    
    
    
    
    //添加代码
    if (IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeAll;               //视图控制器，四条边不指定
        self.extendedLayoutIncludesOpaqueBars = NO;
        //不透明的操作栏<br>
       
        self.modalPresentationCapturesStatusBarAppearance = YES;
        self.navigationController.navigationBar.barTintColor  = Default_Nav_Color;
        self.navigationController.navigationBar.translucent = YES;
    }else{
        self.navigationController.navigationBar.tintColor = Default_Nav_Color;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
