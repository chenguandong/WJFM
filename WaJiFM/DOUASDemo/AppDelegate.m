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

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DOUAudioStreamer.h"
#import "DOUAudioStreamer+Options.h"
#import <AVFoundation/AVFoundation.h>
#import "XMLTools.h"
#import "MusicTableViewMenuController.h"
#import "IIViewDeckController.h"
#import "PlayerViewController.h"
#import "DownLoadTools.h"
#import "XMLBrodCastItem.h"
#import "DownloadTableViewController.h"
#import "MainViewController.h"
#import "BaseUINavigationController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [DOUAudioStreamer setOptions:[DOUAudioStreamer options] | DOUAudioStreamerRequireSHA256];

  [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];

    
    [self initSidingMenu];
    
  [[self window] makeKeyAndVisible];

    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    _playerColl = [PlayerViewController sharedController];
    

    dispatch_async(dispatch_get_main_queue(), ^{
        [[DownloadTableViewController sharedController]startDownLoad];
    });

  return YES;
}




-(void)testDownload{
    NSMutableArray *arra = [NSMutableArray new];

    XMLBrodCastItem *item = [XMLBrodCastItem new];
        item.guid  = @"http://fdfs.xmcdn.com/group5/M02/29/1F/wKgDtlOJO3jgAQwwAOEWLGCdba8671.mp3";
    
    XMLBrodCastItem *item2 = [XMLBrodCastItem new];
    item2.guid  = @"http://fdfs.xmcdn.com/group5/M02/30/AB/wKgDtlOP2FrwEe2KAPyGqZlwetg898.mp3";
    
    [arra addObject:item];
    [arra addObject:item2];

    for (XMLBrodCastItem *bean in arra) {
        TCBlobDownloader *download = [[TCBlobDownloader alloc] initWithURL:[NSURL URLWithString:bean.guid] downloadPath:kDownloadPath delegate:self];
        [[TCBlobDownloadManager sharedInstance] startDownload:download];
        
    }
    

}



-(void)initSidingMenu{
    
     _mainViewController = [MainViewController new];
    
    BaseUINavigationController *mainNavigationController = [[BaseUINavigationController alloc] initWithRootViewController:_mainViewController];
 
    
   _musicMenuColl = [[MusicTableViewMenuController alloc]init];
    

    BaseUINavigationController *leftNav = [[BaseUINavigationController alloc]initWithRootViewController:_musicMenuColl];
   
    
    _deckController =  [[IIViewDeckController alloc] initWithCenterViewController:mainNavigationController leftViewController:
                                             leftNav
                                                                                   rightViewController:nil];


    self.window.rootViewController = _deckController;
    
    
  
}





- (BOOL)canBecomeFirstResponder
{
    return YES;
}





#pragma mark - TCBlobDownloader Delegate


- (void)download:(TCBlobDownloader *)blobDownload didFinishWithSuccess:(BOOL)downloadFinished atPath:(NSString *)pathToFile
{
    NSLog(@"FINISHED");
    NSLog(@"%@",blobDownload.downloadURL);
  
}

- (void)download:(TCBlobDownloader *)blobDownload
  didReceiveData:(uint64_t)receivedLength
         onTotal:(uint64_t)totalLength
        progress:(float)progress
{
    NSLog(@"%f",progress);
}

- (void)download:(TCBlobDownloader *)blobDownload didReceiveFirstResponse:(NSURLResponse *)response
{
    
}

- (void)download:(TCBlobDownloader *)blobDownload didStopWithError:(NSError *)error
{
    
}




- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskAll;
}



@end
