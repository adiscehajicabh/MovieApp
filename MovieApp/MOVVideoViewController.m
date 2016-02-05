//
//  MOVVideoViewController.m
//  MovieApp
//
//  Created by Adis Cehajic on 1/29/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import "MOVVideoViewController.h"

@interface MOVVideoViewController ()

@end

@implementation MOVVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.

    NSURL *videoUrl = [NSURL URLWithString:self.videoUrl];
    NSURLRequest *videoRequest = [NSURLRequest requestWithURL:videoUrl];
    [[self movieVideoPlayer]loadRequest:videoRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
