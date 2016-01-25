//
//  MOVMovieDetailsViewController.m
//  MovieApp
//
//  Created by Adis Cehajic on 24/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import "MOVMovieDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"

@interface MOVMovieDetailsViewController ()

@end

@implementation MOVMovieDetailsViewController

static NSString * const URL_BASE_IMG = @"http://image.tmdb.org/t/p/";
static NSString * const POSTER_SIZE_W720 = @"w1280";
static NSString * const IMAGE_SIZE_W92 = @"w92";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movieDescription.text = self.movie.overview;
    
    // Movie image
    NSURL * urlImage = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, IMAGE_SIZE_W92, self.movie.poster_path]];
    [self.movieImage sd_setImageWithURL:urlImage];
    // Movie poster
    NSURL * urlPoster = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, POSTER_SIZE_W720, self.movie.backdrop_path]];
    [self.moviePoster sd_setImageWithURL:urlPoster];
    
    NSLog(@"%@", urlPoster);
    
    self.movieTitle.text = self.movie.title;
    
    // Release date
    NSString *dateString = self.movie.release_date;
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormater dateFromString:dateString];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    self.movieYear.text = [NSString stringWithFormat:@"(%lu)", [components year]];
    
    self.movieVoteAverage.text = self.movie.vote_average;
    self.movieVoteCount.text = self.movie.vote_count;
    
    
    // Do any additional setup after loading the view.
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
