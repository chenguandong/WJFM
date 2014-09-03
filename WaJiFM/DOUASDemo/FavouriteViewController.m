//
//  FavouriteViewController.m
//  DOUASDemo
//
//  Created by chenguandong on 14-6-15.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import "FavouriteViewController.h"
#import "FavouriteAlbumTableViewController.h"


#import "FavouriteTableViewController.h"
@interface FavouriteViewController ()

@end

@implementation FavouriteViewController

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
     [self.awgment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    FavouriteAlbumTableViewController *favouriteAlbum  = [FavouriteAlbumTableViewController new];
    
    FavouriteTableViewController *favouriteColl = [FavouriteTableViewController new];
    favouriteColl.querySql  = @"select * from favourite ";
    

    _pageContentSize = @[favouriteColl,favouriteAlbum];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    //self.pageController.dataSource = self;
    
    
    [[self.pageController view] setFrame:[[self pageView] bounds]];
    
    
    
    NSArray *viewControllers = @[favouriteColl];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    
    [self addChildViewController:self.pageController];
    [[self pageView] addSubview:[self.pageController view]];
    
    [self.pageController didMoveToParentViewController:self];
   
    

    
}
#pragma mark--  头部选择显示正在下载还是下载完毕

- (void)segmentAction:(id)sender
{
    switch (self.awgment.selectedSegmentIndex) {
        case 0:
            
            [self.pageController setViewControllers:@[_pageContentSize[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
            
            break;
        case 1:
        {
            
            [self.pageController setViewControllers:@[_pageContentSize[1]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}



#pragma mark ----pageview delegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    
    NSUInteger indexNUM = [self.pageContentSize indexOfObject:viewController];
    NSLog(@"viewControllerBeforeViewController------------");
    
    NSLog(@"111 index = %d",indexNUM);
    
    
    
    if ((indexNUM == 0) || (indexNUM == NSNotFound)) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    indexNUM--;
    
    [_awgment setSelectedSegmentIndex:0];
    
    return _pageContentSize[indexNUM];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSLog(@"viewControllerAfterViewController----------------");
    NSUInteger indexNUM = [self.pageContentSize indexOfObject:viewController];
    indexNUM++;
    
    
    if (indexNUM ==2) {
        return nil;
    }
    [_awgment setSelectedSegmentIndex:1];
    
    return _pageContentSize[indexNUM];
    
}


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    NSLog(@"presentationCountForPageViewController-------------");
    return _pageContentSize.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    
    NSLog(@"presentationIndexForPageViewController--------------");
    return 0;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
