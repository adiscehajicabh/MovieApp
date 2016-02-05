//
//  MOVObjectMapping.h
//  MovieApp
//
//  Created by Adis Cehajic on 2/3/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOVMovie.h"
#import "MOVTVShow.h"

@interface MOVObjectMapping : NSObject

+(void)addMovieDurationAndGenres:(MOVMovie *)movie;
+(void)addTvShowDurationAndGenres:(MOVTVShow *)tvShow;

+(void)loadMovie:(NSString *)id loadedMovie:(MOVMovie *)movie;
+(void)loadTVShow:(NSString *)id loadedTVShow:(MOVTVShow *)tvShow;

+(void)addMovieVideo:(MOVMovie *)movie;
+(void)addTVShowVideo:(MOVTVShow *)tvShow;

@end
