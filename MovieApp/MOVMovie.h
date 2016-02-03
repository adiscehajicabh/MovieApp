//
//  MOVMovie.h
//  MovieApp
//
//  Created by Adis Cehajic on 21/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOVGenre.h"

@interface MOVMovie : NSObject

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSString *posterPath;
@property (nonatomic, strong) NSString *releaseDate;
@property (nonatomic, strong) NSString *backdropPath;
@property (nonatomic, strong) NSString *originalTitle;
@property (nonatomic, strong) NSString *voteAverage;
@property (nonatomic, strong) NSString *voteCount;
@property (nonatomic, strong) NSString *runtime;
@property (nonatomic, strong) NSMutableArray *genres;
@property (nonatomic, strong) NSArray *videos;

-(NSAttributedString *)setMovieTitleAndYear:(MOVMovie *)movie;
//-(NSURL *)posterUrl;
-(void)convertMovieGenres:(RLMArray *)movieGenresRLM;


@end
