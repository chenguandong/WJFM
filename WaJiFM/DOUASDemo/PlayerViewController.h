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

#import <UIKit/UIKit.h>
#import "MusicPlayViewController.h"
#import "DOUAudioStreamer.h"
@interface PlayerViewController : BaseViewController
@property NSUInteger currentTrackIndex;
@property (nonatomic, strong) NSArray *tracks;
@property(nonatomic,strong)NSArray *musicDetail;
@property(nonatomic,strong)MusicPlayViewController *musicColl;
@property(nonatomic,strong)DOUAudioStreamer *streamer;

+(PlayerViewController *) sharedController;

/**
 上一首
 */
-(void)_actionPrevious:(id)sender;
/**
 下一首
 */
- (void)_actionNext:(id)sender;
/**
 停止播放
 */
- (void)_actionStop:(id)sender;
/**
 暂停播放
 */
- (void)_actionPlayPause:(id)sender;


@property (weak, nonatomic) IBOutlet UIImageView *audioImgView;

@property (weak, nonatomic) IBOutlet UIButton *buttonPlayPause;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlayPrevious;
@property (weak, nonatomic) IBOutlet UIButton *buttonNext;

@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *miscLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;

@end
