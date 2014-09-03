//
//  MusicPlayViewController.m
//  DOUASDemo
//
//  Created by chenguandong on 14-6-11.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import "MusicPlayViewController.h"
#import "PlayerViewController.h"
#import "MarqueeLabel.h"
@interface MusicPlayViewController ()

@end

@implementation MusicPlayViewController

static MusicPlayViewController *sharedRootController = nil;


+(MusicPlayViewController *) sharedController{
    @synchronized(self)
    {
        if (sharedRootController == nil)
        {
            sharedRootController = [[self alloc] init];
        }
    }
    return sharedRootController;
    
}

-(IBAction)previous:(id)sender{
    [_doubanPlayer _actionPrevious:sender];
}
-(IBAction)play:(id)sender{
    [_doubanPlayer _actionPlayPause:sender];
}

-(IBAction)next:(id)sender{
    [_doubanPlayer _actionNext:sender];
}

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
    

//    MarqueeLabel *scrollyLabelTitle = [[MarqueeLabel alloc] initWithFrame:_musicTitle.frame rate:12.0 andFadeLength:10.0f];
//    scrollyLabelTitle.textColor = [UIColor orangeColor];
//    scrollyLabelTitle.font = [UIFont systemFontOfSize:17];
//    _musicTitle = scrollyLabelTitle;
//    [self.view addSubview:scrollyLabelTitle];
    
    
    //设置音乐标题和字体样式
    _musicSubtitle.textColor = [UIColor whiteColor];
    _musicTitle.textColor = [UIColor whiteColor];
    _musicSubtitle.font  =[UIFont systemFontOfSize:12];

    _musicTitle.backgroundColor = [UIColor clearColor];
    _musicSubtitle.backgroundColor = [UIColor clearColor];
    
    //滚动速率
    _musicTitle.rate = 12;
    _musicSubtitle.rate = 10;
    
    //滚动类型
    
    _musicTitle.marqueeType = MLContinuous;
    _musicSubtitle.marqueeType = MLContinuous;
    
    
    // Do any additional setup after loading the view from its nib.
    _doubanPlayer = [PlayerViewController sharedController];
    _streamer = _doubanPlayer.streamer;
    
 
    //设置progrebar 样式

//    [_musicProgress setThumbImage:img forState:UIControlStateNormal];
//     [_musicProgress setThumbImage:img forState:UIControlStateHighlighted];
   
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 2.0f);
    
    _musicProgress.transform =transform;
    
    [_previousButton setImage:[UIImage imageNamed:@"play_btn_prev_prs"] forState:UIControlStateHighlighted];
    [_nextButton setImage:[UIImage imageNamed:@"play_btn_next_prs"] forState:UIControlStateHighlighted];
    
   // [_musicProgress addTarget:self action:@selector(actionSliderProgress:) forControlEvents:UIControlEventValueChanged];
    
   
}






- (void)actionSliderProgress:(id)sender
{
    [_streamer setCurrentTime:[_streamer duration] * [_musicProgress progress]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
