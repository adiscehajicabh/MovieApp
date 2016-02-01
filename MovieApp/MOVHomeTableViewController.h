//
//  MOVHomeTableViewController.h
//  MovieApp
//
//  Created by Adis Cehajic on 20/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOVHomeTableViewCell.h"


@interface MOVHomeTableViewController : UITableViewController <MOVHomeTableViewCellDelegate>

// Declaring variables for each category.
@property (nonatomic, strong) NSArray *topRatedMovies;
@property (nonatomic, strong) NSArray *popularMovies;
@property (nonatomic, strong) NSArray *upcomingMovies;
@property (nonatomic, strong) NSArray *topRatedSeries;
@property (nonatomic, strong) NSArray *popularSeries;

// Declaring variables that represent selected movie.
@property (nonatomic, strong) MOVMovie *selectedMovie;
@property (nonatomic, strong) MOVTVShow *selectedSerie;

@end
