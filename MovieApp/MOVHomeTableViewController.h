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
@property (nonatomic, strong) NSMutableArray *topRatedMovies;
@property (nonatomic, strong) NSMutableArray *popularMovies;
@property (nonatomic, strong) NSMutableArray *upcomingMovies;
@property (nonatomic, strong) NSMutableArray *topRatedSeries;
@property (nonatomic, strong) NSMutableArray *popularSeries;

// Declaring variables that represent selected movie.
@property (nonatomic, strong) MOVMovie *selectedMovie;
@property (nonatomic, strong) MOVTVShow *selectedSerie;

@end
