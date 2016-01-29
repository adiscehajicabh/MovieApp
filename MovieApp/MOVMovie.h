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
@property (nonatomic, strong) NSString *poster_path;
@property (nonatomic, strong) NSString *release_date;
@property (nonatomic, strong) NSString *backdrop_path;
@property (nonatomic, strong) NSString *vote_average;
@property (nonatomic, strong) NSString *vote_count;
@property (nonatomic, strong) NSString *runtime;
@property (nonatomic, strong) NSArray *genres;
@property (nonatomic, strong) NSArray *videos;

@end
