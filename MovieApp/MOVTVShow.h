//
//  MOVTVShow.h
//  MovieApp
//
//  Created by Adis Cehajic on 24/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOVTVShow : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSString *poster_path;
@property (nonatomic, strong) NSString *first_air_date;
@property (nonatomic, strong) NSString *backdrop_path;
@property (nonatomic, strong) NSString *vote_average;
@property (nonatomic, strong) NSString *vote_count;
@property (nonatomic, strong) NSArray *genres;
@property (nonatomic, strong) NSArray *episode_run_time;
@property (nonatomic, strong) NSArray *videos;

-(NSAttributedString *)setTVShowTitleAndYear:(MOVTVShow *)tvShow;

@end
