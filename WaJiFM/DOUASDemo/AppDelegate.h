/* vim: set ft=objc fenc=utf-8 sw=2 ts=2 et: */
/*
 *  DOUAudioStreamer - A Core Audio based streaming audio player for iOS/Mac:
 *
 *      https://github.com/douban/DOUAudioStreamer
        https://www.waji.com
 
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

#import <UIKit/UIKit.h>
#import "MusicTableViewMenuController.h"
#import "MainViewController.h"
#import "PlayerViewController.h"
#import "ViewDeck/IIViewDeckController.h"
#import "PlayerViewController.h"
#import "DownloadTableViewController.h"
#import "MainViewController.h"

@class MainViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,TCBlobDownloaderDelegate>

@property (nonatomic, strong) UIWindow *window;

@property(nonatomic,strong) MusicTableViewMenuController *musicMenuColl;

@property(nonatomic,strong)MainViewController *mainViewController;

@property(nonatomic,strong)PlayerViewController *playerColl;

@property(nonatomic,strong)IIViewDeckController* deckController;


@end
