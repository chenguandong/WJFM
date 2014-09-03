//
//  MusicPlayViewController.h
//  DOUASDemo
//
//  Created by chenguandong on 14-6-11.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MarqueeLabel;
@class PlayerViewController;
@class DOUAudioStreamer;
@interface MusicPlayViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *musicImg;

@property (weak, nonatomic) IBOutlet UIProgressView *musicProgress;
@property (weak, nonatomic) IBOutlet MarqueeLabel *musicTitle;
@property (weak, nonatomic) IBOutlet MarqueeLabel *musicSubtitle;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property(weak,nonatomic)PlayerViewController *doubanPlayer;
-(IBAction)previous:(id)sender;
-(IBAction)play:(id)sender;
-(IBAction)next:(id)sender;
@property(nonatomic,strong)DOUAudioStreamer *streamer;

+(MusicPlayViewController *) sharedController;
@end
