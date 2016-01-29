//
//  MOVVideoViewController.h
//  MovieApp
//
//  Created by Adis Cehajic on 1/29/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOVVideoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *movieVideoPlayer;
@property (nonatomic, strong) NSString *videoUrl;

@end
