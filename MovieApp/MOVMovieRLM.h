//
//  MOVMovieRLM.h
//  MovieApp
//
//  Created by Adis Cehajic on 2/1/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <Realm/Realm.h>
#import "MOVGenreRLM.h"
#import "MOVVideoRLM.h"

@interface MOVMovieRLM : RLMObject

@property NSString *id;

@property NSString *title;
@property NSString *overview;
@property NSString *poster_path;
@property NSString *release_date;
@property NSString *backdrop_path;
@property NSString *vote_average;
@property NSString *vote_count;
@property NSString *runtime;
@property NSString *genres;

-(NSAttributedString *)setMovieTitleAndYear:(MOVMovieRLM *)movie;

@end

