//
//  MOVObjectMapping.m
//  MovieApp
//
//  Created by Adis Cehajic on 2/3/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import "MOVObjectMapping.h"
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

+(RKObjectMapping *)createGenreMapping {
    
    // Create our new Genre mapping
    RKObjectMapping *genreMapping = [RKObjectMapping mappingForClass:[MOVGenre class]];
    
    [genreMapping addAttributeMappingsFromArray:@[ @"id", @"name" ]];
    
    return genreMapping;
}


@end
