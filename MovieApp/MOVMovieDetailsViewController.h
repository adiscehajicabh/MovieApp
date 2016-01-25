//
//  MOVMovieDetailsViewController.h
//  MovieApp
//
//  Created by Adis Cehajic on 24/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOVMovie.h"
#import "MOVMovieDetailsViewController.h"



@interface MOVMovieDetailsViewController : UIViewController



@property (nonatomic, strong) MOVMovie *movie;

@property (strong, nonatomic) IBOutlet UINavigationItem *navbarTitle;
@property (weak, nonatomic) IBOutlet UIImageView *moviePoster;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieYear;
@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet UITextView *movieDescription;
@property (weak, nonatomic) IBOutlet UILabel *movieVoteAverage;
@property (weak, nonatomic) IBOutlet UILabel *movieVoteCount;

@property (nonatomic, strong) NSString *moviePosterContent;
@property (nonatomic, strong) NSString *movieTitleContent;
@property (nonatomic, strong) NSString *movieYearContent;
@property (nonatomic, strong) NSString *movieImageContent;
@property (nonatomic, strong) NSString *movieDescriptionContent;
@property (nonatomic, strong) NSString *movieVoteAverageContent;
@property (nonatomic, strong) NSString *movieVoteCountContent;

@end
