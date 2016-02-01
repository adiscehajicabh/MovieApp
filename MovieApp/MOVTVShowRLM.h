//
//  MOVTVShowRLM.h
//  MovieApp
//
//  Created by Adis Cehajic on 2/1/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <Realm/Realm.h>

@interface MOVTVShowRLM : RLMObject

@property NSString *id;
@property NSString *name;
@property NSString *overview;
@property NSString *poster_path;
@property NSString *first_air_date;
@property NSString *backdrop_path;
@property NSString *vote_average;
@property NSString *vote_count;

//@property NSArray *genres;
//@property NSArray *episode_run_time;
//@property NSArray *videos;

@end

