//
//  MOVObjectMapping.m
//  MovieApp
//
//  Created by Adis Cehajic on 2/3/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import "MOVObjectMapping.h"
#import "MOVDuration.h"
#import "MOVVideo.h"
#import <RestKit/RestKit.h>


@implementation MOVObjectMapping




/*
 * Updates the inputed movie information. It sets the movie runtime and movie genres.
 *
 *
 */
+(void)addMovieDurationAndGenres:(MOVMovie *)movie {
    
    // Configuring the Movie mapping
    RKObjectMapping *movieMapping = [RKObjectMapping mappingForClass:[MOVMovie class]];
    [movieMapping addAttributeMappingsFromDictionary:@{
                                                       @"id" : @"id",
                                                       @"title" : @"title",
                                                       @"overview" : @"overview",
                                                       @"poster_path" : @"posterPath",
                                                       @"release_date" : @"releaseDate",
                                                       @"backdrop_path" : @"backdropPath",
                                                       @"vote_average" : @"voteAverage",
                                                       @"vote_count" : @"voteCount",
                                                       @"runtime": @"runtime",
                                                       }];
    
    // Define the relationship mapping
    [movieMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"genres"
                                                                                 toKeyPath:@"genres"
                                                                               withMapping:[self createGenreMapping]]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil
                                                                                           keyPath:@""
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%d?api_key=34aa7e1baaee7e047801a1a8454587b8", [movie.id intValue]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//        self.selectedMovies = mappingResult.firstObject;
        //[self.movieCastCollectionView reloadData];
        MOVMovie *clickedMovie = mappingResult.firstObject;
        [movie setRuntime:clickedMovie.runtime];
        [movie setGenres:clickedMovie.genres];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Could not load movie cast from API!': %@", error);
    }];
    
    [objectRequestOperation start];
    
}

+(void)loadMovie:(NSString *)id loadedMovie:(MOVMovie *)movie {
   
    // Configuring the Movie mapping
    RKObjectMapping *movieMapping = [RKObjectMapping mappingForClass:[MOVMovie class]];
    [movieMapping addAttributeMappingsFromDictionary:@{
                                                       @"id" : @"id",
                                                       @"title" : @"title",
                                                       @"overview" : @"overview",
                                                       @"poster_path" : @"posterPath",
                                                       @"release_date" : @"releaseDate",
                                                       @"backdrop_path" : @"backdropPath",
                                                       @"vote_average" : @"voteAverage",
                                                       @"vote_count" : @"voteCount",
                                                       @"runtime": @"runtime",
                                                       }];
    
    // Define the relationship mapping
    [movieMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"genres"
                                                                                 toKeyPath:@"genres"
                                                                               withMapping:[self createGenreMapping]]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil
                                                                                           keyPath:@""
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=34aa7e1baaee7e047801a1a8454587b8", id]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        MOVMovie *clickedMovie = mappingResult.firstObject;
        [movie setRuntime:clickedMovie.runtime];
        [movie setGenres:clickedMovie.genres];
        [movie setId:clickedMovie.id];
        [movie setTitle:clickedMovie.title];
        [movie setOverview:clickedMovie.overview];
        [movie setPosterPath:clickedMovie.posterPath];
        [movie setReleaseDate:clickedMovie.releaseDate];
        [movie setBackdropPath:clickedMovie.backdropPath];
        [movie setOriginalTitle:clickedMovie.originalTitle];
        [movie setVoteAverage:clickedMovie.voteAverage];
        [movie setVoteCount:clickedMovie.voteCount];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Could not load movie cast from API!': %@", error);
    }];
    
    [objectRequestOperation start];
}

/*
 * Updates the inputed movie information. It sets the movie runtime and movie genres.
 *
 *
 */
+(void)addTvShowDurationAndGenres:(MOVTVShow *)tvShow {
    
    RKObjectMapping *durationMapping = [RKObjectMapping mappingForClass:[MOVDuration class]];
    
    // Configuring the Movie mapping
    RKObjectMapping *tvShowMapping = [RKObjectMapping mappingForClass:[MOVTVShow class]];
    [tvShowMapping addAttributeMappingsFromDictionary:@{
                                                        @"id" : @"id",
                                                        @"name" : @"name",
                                                        @"overview" : @"overview",
                                                        @"poster_path" : @"posterPath",
                                                        @"first_air_date" : @"firstAirDate",
                                                        @"backdrop_path" : @"backdropPath",
                                                        @"vote_average" : @"voteAverage",
                                                        @"vote_count" : @"voteCount"
                                                        }];
    
    // Define the relationship mapping
    [tvShowMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"genres"
                                                                                  toKeyPath:@"genres"
                                                                                withMapping:[self createGenreMapping]]];
    
    [durationMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"duration"]];
    
    [tvShowMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"episode_run_time"
                                                                                  toKeyPath:@"episodeRunTime"
                                                                                withMapping:durationMapping]];
    
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:tvShowMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil
                                                                                           keyPath:@""
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.themoviedb.org/3/tv/%d?api_key=34aa7e1baaee7e047801a1a8454587b8", [tvShow.id intValue]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //self.selectedTvShows = mappingResult.array;
        //[self.movieCastCollectionView reloadData];
        MOVTVShow *clickedTvShow = mappingResult.firstObject;
        [tvShow setGenres:clickedTvShow.genres];
        [tvShow setEpisodeRunTime:clickedTvShow.episodeRunTime];
        
        MOVDuration *tvShowDuration = [clickedTvShow.episodeRunTime objectAtIndex:0];
        [tvShow setDuration:tvShowDuration.duration];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Could not load movie cast from API!': %@", error);
    }];
    
    [objectRequestOperation start];
    
}

+(void)loadTVShow:(NSString *)id loadedTVShow:(MOVTVShow *)tvShow {
    
    RKObjectMapping *durationMapping = [RKObjectMapping mappingForClass:[MOVDuration class]];
    
    // Configuring the Movie mapping
    RKObjectMapping *tvShowMapping = [RKObjectMapping mappingForClass:[MOVTVShow class]];
    [tvShowMapping addAttributeMappingsFromDictionary:@{
                                                        @"id" : @"id",
                                                        @"name" : @"name",
                                                        @"overview" : @"overview",
                                                        @"poster_path" : @"posterPath",
                                                        @"first_air_date" : @"firstAirDate",
                                                        @"backdrop_path" : @"backdropPath",
                                                        @"vote_average" : @"voteAverage",
                                                        @"vote_count" : @"voteCount"
                                                        }];
    
    // Define the relationship mapping
    [tvShowMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"genres"
                                                                                  toKeyPath:@"genres"
                                                                                withMapping:[self createGenreMapping]]];
    
    [durationMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"duration"]];
    
    [tvShowMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"episode_run_time"
                                                                                  toKeyPath:@"episodeRunTime"
                                                                                withMapping:durationMapping]];
    
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:tvShowMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil
                                                                                           keyPath:@""
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.themoviedb.org/3/tv/%@?api_key=34aa7e1baaee7e047801a1a8454587b8", id]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        MOVTVShow *clickedTvShow = mappingResult.firstObject;
        
        [tvShow setId:clickedTvShow.id];
        [tvShow setName:clickedTvShow.name];
        [tvShow setOverview:clickedTvShow.overview];
        [tvShow setPosterPath:clickedTvShow.posterPath];
        [tvShow setFirstAirDate:clickedTvShow.firstAirDate];
        [tvShow setBackdropPath:clickedTvShow.backdropPath];
        [tvShow setVoteAverage:clickedTvShow.voteAverage];
        [tvShow setVoteCount:clickedTvShow.voteCount];
        [tvShow setGenres:clickedTvShow.genres];
        [tvShow setEpisodeRunTime:clickedTvShow.episodeRunTime];
        
        if([clickedTvShow.episodeRunTime count] > 0) {
            MOVDuration *tvShowDuration = [clickedTvShow.episodeRunTime objectAtIndex:0];
            [tvShow setDuration:tvShowDuration.duration];
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Could not load movie cast from API!': %@", error);
    }];
    
    [objectRequestOperation start];
    
}


+(RKObjectMapping *)createGenreMapping {
    
    // Create our new Genre mapping
    RKObjectMapping *genreMapping = [RKObjectMapping mappingForClass:[MOVGenre class]];
    
    [genreMapping addAttributeMappingsFromArray:@[ @"id", @"name" ]];
    
    return genreMapping;
}

/*
 * Updates the inputed movie information. It sets the movie videos.
 *
 *
 */
+(void)addMovieVideo:(MOVMovie *)movie {
    
//    // Setup object mappings for videos
//    RKObjectMapping *videoMapping = [RKObjectMapping mappingForClass:[MOVVideo class]];
//    [videoMapping addAttributeMappingsFromDictionary:@{
//                                                       @"id": @"id",
//                                                       @"key": @"key",
//                                                       @"name": @"name",
//                                                       @"site" : @"site",
//                                                       @"size" : @"size",
//                                                       @"type" : @"type"
//                                                       }];
    
    // Register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self createVideoMapping] method:RKRequestMethodAny pathPattern:nil keyPath:@"results" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%d/videos?api_key=eeeda4aeb01446fa9cabef99fab242af", [movie.id intValue]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        movie.videos = mappingResult.array;
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Could not load movie cast from API!': %@", error);
    }];
    
    [objectRequestOperation start];

}

/*
 * Updates the inputed tv show information. It sets the tv show videos.
 *
 *
 */
+(void)addTVShowVideo:(MOVTVShow *)tvShow {
    
    // Register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self createVideoMapping] method:RKRequestMethodAny pathPattern:nil keyPath:@"results" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.themoviedb.org/3/tv/%d/videos?api_key=eeeda4aeb01446fa9cabef99fab242af", [tvShow.id intValue]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        tvShow.videos = mappingResult.array;
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Could not load movie cast from API!': %@", error);
    }];
    
    [objectRequestOperation start];
    
    
}


+(RKObjectMapping *)createVideoMapping {
    
    // Setup object mappings for videos
    RKObjectMapping *videoMapping = [RKObjectMapping mappingForClass:[MOVVideo class]];
    [videoMapping addAttributeMappingsFromDictionary:@{
                                                       @"id": @"id",
                                                       @"key": @"key",
                                                       @"name": @"name",
                                                       @"site" : @"site",
                                                       @"size" : @"size",
                                                       @"type" : @"type"
                                                       }];
    return videoMapping;
}

@end
