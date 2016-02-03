//
//  MOVTVShow.h
//  MovieApp
//
//  Created by Adis Cehajic on 24/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface MOVTVShow : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSString *posterPath;
@property (nonatomic, strong) NSString *firstAirDate;
@property (nonatomic, strong) NSString *backdropPath;
@property (nonatomic, strong) NSString *voteAverage;
@property (nonatomic, strong) NSString *voteCount;
@property (nonatomic, strong) NSMutableArray *genres;
@property (nonatomic, strong) NSArray *episodeRunTime;
@property (nonatomic, strong) NSArray *videos;
@property (nonatomic, strong) NSString *duration;

-(NSAttributedString *)setTVShowTitleAndYear:(MOVTVShow *)tvShow;
-(void)convertTVShowGenres:(RLMArray *)tvShowGenresRLM;


@end
