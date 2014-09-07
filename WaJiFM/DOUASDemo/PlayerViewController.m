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

#import "PlayerViewController.h"
#import "Track.h"
#import "DOUAudioStreamer.h"
#import "DOUAudioVisualizer.h"
#import <AVFoundation/AVFoundation.h>
#import "DownLoadTools.h"
#import "MusicPlayViewController.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "MarqueeLabel.h"
#import "SqlTools.h"
#import "UIImageView+LBBlurredImage.h"
static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface PlayerViewController () {

@private

  
  NSTimer *_timer;

  
  DOUAudioVisualizer *_audioVisualizer;

}
@end

@implementation PlayerViewController


static PlayerViewController *sharedRootController = nil;

+(PlayerViewController *) sharedController{
    
    @synchronized(self)
    {
        if (sharedRootController == nil)
        {
            sharedRootController = [[self alloc] init];
        }
    }
    return sharedRootController;
}

-(void)viewDidLoad{
    

     _musicColl = [MusicPlayViewController sharedController];
    
    //privious
    [_buttonPlayPrevious setImage:[UIImage imageNamed:@"play_btn_prev"] forState:UIControlStateNormal];
    [_buttonPlayPrevious setImage:[UIImage imageNamed:@"play_btn_prev_prs"] forState:UIControlStateHighlighted];
    
    [_buttonPlayPrevious addTarget:self action:@selector(_actionPrevious:) forControlEvents:UIControlEventTouchDown];
    
    
    
    
    //play
    [_buttonPlayPause setImage:[UIImage imageNamed:@"play_ctrl_play_prs"] forState:UIControlStateNormal];
    [_buttonPlayPause setImage:[UIImage imageNamed:@"play_ctrl_play"] forState:UIControlStateHighlighted];
    
    [_buttonPlayPause addTarget:self action:@selector(_actionPlayPause:) forControlEvents:UIControlEventTouchDown];
    
    
    
    
    
    [_buttonNext setImage:[UIImage imageNamed:@"play_btn_next"] forState:UIControlStateNormal];
    [_buttonNext setImage:[UIImage imageNamed:@"play_btn_next_prs"] forState:UIControlStateHighlighted];
    
    [_buttonNext addTarget:self action:@selector(_actionNext:) forControlEvents:UIControlEventTouchDown];
    
    
    
    
    [_progressSlider addTarget:self action:@selector(_actionSliderProgress:) forControlEvents:UIControlEventValueChanged];
    
    
    [_volumeSlider addTarget:self action:@selector(_actionSliderVolume:) forControlEvents:UIControlEventValueChanged];
    
    
    //  _audioVisualizer = [[DOUAudioVisualizer alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY([_volumeSlider frame]), CGRectGetWidth([self.view bounds]), CGRectGetHeight([self.view  bounds]) - CGRectGetMaxY([_volumeSlider frame]))];
    //  [_audioVisualizer setBackgroundColor:[UIColor colorWithRed:239.0 / 255.0 green:244.0 / 255.0 blue:240.0 / 255.0 alpha:1.0]];
    //  [self.view addSubview:_audioVisualizer];
    
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_timerAction:) userInfo:nil repeats:YES];
    
    if (IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    

}

- (void)_cancelStreamer
{
  if (_streamer != nil) {
    [_streamer pause];
    [_streamer removeObserver:self forKeyPath:@"status"];
    [_streamer removeObserver:self forKeyPath:@"duration"];
    [_streamer removeObserver:self forKeyPath:@"bufferingRatio"];
    _streamer = nil;
  }
}


//开始播放 每次重新开始播放   历史记录应该放在这个位置
- (void)_resetStreamer
{
  [self _cancelStreamer];

    if (0 == [_tracks count])
    {
        [_miscLabel setText:@"(No tracks available)"];
    }
    else
    {
        Track *track = [_tracks objectAtIndex:_currentTrackIndex];
        NSString *title = [NSString stringWithFormat:@"%@ - %@", track.artist, track.title];
        [_titleLabel setText:title];
        
        _streamer = [DOUAudioStreamer streamerWithAudioFile:track];
        [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
        [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
        [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
        
        [_streamer play];
        
        //插入历史记录
        [self insertHistory];

        _musicColl.musicTitle.text =track.title;
        _musicColl.musicSubtitle.text = track.subTitle;
        [_musicColl.musicImg setImageWithURL:[NSURL URLWithString:track.audioImg] placeholderImage:[UIImage imageNamed:@"default_album_sml"]];
        
        _audioImgView.hidden = YES;
        
        
        [_audioImgView setImageWithURL:[NSURL URLWithString:track.audioImg] placeholderImage:[UIImage imageNamed:@"80.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (!error) {
                [_audioImgView setImageToBlur:_audioImgView.image blurRadius:0.1 completionBlock:^{
                    _audioImgView.hidden = NO;
                }];
                

            }
            if (error) {
                _audioImgView.hidden = NO;
                [_audioImgView setImage:[UIImage imageNamed:@"80.jpg"]];

            }
        }];
        
        
       
        
        [self _updateBufferingStatus];
        [self _setupHintForStreamer];
    }
}



//插入历史记录到数据库
-(void)insertHistory{
    __block BOOL inertState;
    [SqlTools getFMdatabase:[SqlTools getHistoryDBSQL] :[SqlTools getHistoryDBPath]];

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        // time-consuming task
        inertState =  [SqlTools insertHistoryDate:_musicDetail[_currentTrackIndex]];
        
        dispatch_async(dispatch_get_main_queue(),^{
            if (inertState) {
                NSLog(@"插入历史记录成功.....");
            }else{
                NSLog(@"插入历史记录失败....");
            }
            
        });
    });
}



- (void)_setupHintForStreamer
{
  NSUInteger nextIndex = _currentTrackIndex + 1;
  if (nextIndex >= [_tracks count]) {
    nextIndex = 0;
  }

  [DOUAudioStreamer setHintWithAudioFile:[_tracks objectAtIndex:nextIndex]];
}

- (void)_timerAction:(id)timer
{
  if ([_streamer duration] == 0.0) {
    [_progressSlider setValue:0.0f animated:NO];
      
      //外部进度条

    [_musicColl.musicProgress setProgress:0.0f animated:NO];

  }
  else {
    [_progressSlider setValue:[_streamer currentTime] / [_streamer duration] animated:NO];
      
      
      [_musicColl.musicProgress setProgress:[_streamer currentTime] / [_streamer duration] animated:NO];

      
  }
    

}

- (void)_updateStatus
{
  switch ([_streamer status]) {
  case DOUAudioStreamerPlaying:
    [_statusLabel setText:@"playing"];
    
           [_buttonPlayPause setImage:[UIImage imageNamed:@"play_ctrl_pause_prs.png"] forState:UIControlStateNormal];

          
          //播放器界面播放按钮设置
          [_musicColl.playButton setImage:[UIImage imageNamed:@"play_ctrl_pause_prs.png"] forState:UIControlStateNormal];
    
    break;

  case DOUAudioStreamerPaused:
    [_statusLabel setText:@"paused"];
    
          
           [_buttonPlayPause setImage:[UIImage imageNamed:@"play_ctrl_play_prs"] forState:UIControlStateNormal];
          
          
          //播放器界面播放按钮设置
          [_musicColl.playButton setImage:[UIImage imageNamed:@"play_ctrl_play_prs"] forState:UIControlStateNormal];
    break;

  case DOUAudioStreamerIdle:
    [_statusLabel setText:@"idle"];
    [_buttonPlayPause setTitle:@"Play" forState:UIControlStateNormal];
    break;

  case DOUAudioStreamerFinished:
    [_statusLabel setText:@"finished"];
    [self _actionNext:nil];
    
    
    break;

  case DOUAudioStreamerBuffering:
    [_statusLabel setText:@"buffering"];
    break;

  case DOUAudioStreamerError:
    [_statusLabel setText:@"error"];
    break;
  }
}

- (void)_updateBufferingStatus
{
  [_miscLabel setText:[NSString stringWithFormat:@"Received %.2f/%.2f MB (%.2f %%), Speed %.2f MB/s", (double)[_streamer receivedLength] / 1024 / 1024, (double)[_streamer expectedLength] / 1024 / 1024, [_streamer bufferingRatio] * 100.0, (double)[_streamer downloadSpeed] / 1024 / 1024]];

  if ([_streamer bufferingRatio] >= 1.0) {
    NSLog(@"sha256: %@", [_streamer sha256]);
  }
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (context == kStatusKVOKey) {
    [self performSelector:@selector(_updateStatus)
                 onThread:[NSThread mainThread]
               withObject:nil
            waitUntilDone:NO];
  }
  else if (context == kDurationKVOKey) {
    [self performSelector:@selector(_timerAction:)
                 onThread:[NSThread mainThread]
               withObject:nil
            waitUntilDone:NO];
  }
  else if (context == kBufferingRatioKVOKey) {
    [self performSelector:@selector(_updateBufferingStatus)
                 onThread:[NSThread mainThread]
               withObject:nil
            waitUntilDone:NO];
  }
  else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
   
    
    if (_currentTrackIndex!=-1) {
        [self _resetStreamer];
    }
    
    if (!_streamer) {
        
        [_volumeSlider setValue:[DOUAudioStreamer volume]];
        
        //告诉系统，我们要接受远程控制事件
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        [self becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
//  [_timer invalidate];
//  [_streamer stop];
//  [self _cancelStreamer];

  [super viewWillDisappear:animated];
    
//    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
//    
//    [self resignFirstResponder];
}

- (void)_actionPlayPause:(id)sender
{
  if ([_streamer status] == DOUAudioStreamerPaused ||
      [_streamer status] == DOUAudioStreamerIdle) {
    [_streamer play];
  }
  else {
    [_streamer pause];
  }
}
-(void)_actionPrevious:(id)sender{
    

    _currentTrackIndex = _currentTrackIndex-1;
    if ((int)_currentTrackIndex < 0) {
        
        _currentTrackIndex =([_tracks count]-1);
        NSLog(@"xxx%d",_currentTrackIndex);
    }
    
    NSLog(@"%d???",_currentTrackIndex);
    
    [self _resetStreamer];
}


- (void)_actionNext:(id)sender
{
  if (++_currentTrackIndex >= [_tracks count]) {
    _currentTrackIndex = 0;
  }

  [self _resetStreamer];
}

#pragma mark  -暂停
- (void)_actionStop:(id)sender
{
  [_streamer stop];
}

- (void)_actionSliderProgress:(id)sender
{
  [_streamer setCurrentTime:[_streamer duration] * [_progressSlider value]];
}

- (void)_actionSliderVolume:(id)sender
{
  [DOUAudioStreamer setVolume:[_volumeSlider value]];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}
-(void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent{
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
               //  [[PlayController sharedInstance] pause];
                

                NSLog(@"RemoteControlEvents: pause");
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                // [[PlayController sharedInstance] playModeNext];
                NSLog(@"RemoteControlEvents: playModeNext");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                //  [[PlayController sharedInstance] playPrev];
                NSLog(@"RemoteControlEvents: playPrev");
                break;
            default:
                break;
        }
    }
}



@end
