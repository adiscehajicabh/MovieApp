//
//  MOVHomeTableViewCell.m
//  MovieApp
//
//  Created by Adis Cehajic on 20/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import "MOVHomeTableViewCell.h"
#import "MOVCollectionViewCell.h"
#import "MOVMovie.h"
#import "MOVTVShow.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"
#import "MOVMovieDetailsViewController.h"
#import "MOVMovie.h"
#import "MOVGenre.h"
#import "MOVDuration.h"
#import <RestKit/RestKit.h>
#import "MOVVideo.h"
#import "MOVObjectMapping.h"


@implementation MOVHomeTableViewCell

static NSString * const reuseIdentifier = @"CollectionCell";
static NSString * const URL_BASE_IMG = @"http://image.tmdb.org/t/p/";
static NSString * const POSTER_SIZE_W92 = @"w92";

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MOVCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return [self loadMoviesInCategories:self.movies cellAtIndex:cell cellIndex:indexPath];

}

- (MOVCollectionViewCell *)loadMoviesInCategories:(NSArray *)movies cellAtIndex:(MOVCollectionViewCell *)cell cellIndex:(NSIndexPath *)indexPath {
    
    // Configure the cell
    // Finding movie for each cell and setting the title, year and the poster of the movie
    if ([[movies objectAtIndex:indexPath.row] isKindOfClass:[MOVMovie class]]) {
        
        // Title
        MOVMovie *movie = [movies objectAtIndex:indexPath.row];
        cell.movieTitleCell.text = movie.title;
        
        [MOVObjectMapping addMovieDurationAndGenres:movie];
        [self addMovieVideo:movie];
        
        if (movie.posterPath != nil) {
            
            // Movie poster
            NSURL * url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, POSTER_SIZE_W92, movie.posterPath]];
            [cell.movieImageCell sd_setImageWithURL:url];
        
        } else {
            UIImage *movImage = [UIImage imageNamed:@"movie_placeholder.png"];
            cell.movieImageCell.image = movImage;
        }
        
        // Release date
        cell.movieYearCell.text = [self insertMovieDate:movie];
    
    } else {
        // Title
        MOVTVShow *serie = [movies objectAtIndex:indexPath.row];
        cell.movieTitleCell.text = serie.name;
        
        [MOVObjectMapping addTvShowDurationAndGenres:serie];
        [self addTVShowVideo:serie];
        
        // Movie poster
        NSURL * url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, POSTER_SIZE_W92, serie.posterPath]];
        [cell.movieImageCell sd_setImageWithURL:url];
        
        // Release date
        NSString *dateString = serie.firstAirDate;
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormater dateFromString:dateString];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
        cell.movieYearCell.text = [NSString stringWithFormat:@"%lu", [components year]];
    }
    
    // Rounding the cell image corners.
    cell.movieImageCell.layer.cornerRadius = 5;
    cell.movieImageCell.layer.masksToBounds = YES;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    // Checking if the selected object is the movie or tv show and returning to the movie view selected object.
    if ([[self.movies objectAtIndex:indexPath.row] isKindOfClass:[MOVMovie class]]) {

        MOVMovie *movie = [self.movies objectAtIndex:indexPath.row];

        [self.delegate addSegueMovie:movie];
    } else {
        
        MOVTVShow *serie = [self.movies objectAtIndex:indexPath.row];
        
        [self.delegate addSegueSerie:serie];
    }
}

///*
// * Updates the inputed movie information. It sets the movie runtime and movie genres.
// *
// *
// */
//-(void)addMovieDurationAndGenres:(MOVMovie *)movie {
//    
//    // Create our new Genre mapping
//    RKObjectMapping *genreMapping = [RKObjectMapping mappingForClass:[MOVGenre class]];
//    
//    [genreMapping addAttributeMappingsFromArray:@[ @"id", @"name" ]];
//    
//    // Configuring the Movie mapping
//    RKObjectMapping *movieMapping = [RKObjectMapping mappingForClass:[MOVMovie class]];
//    [movieMapping addAttributeMappingsFromDictionary:@{
//                                                       @"id" : @"id",
//                                                       @"title" : @"title",
//                                                       @"overview" : @"overview",
//                                                       @"poster_path" : @"posterPath",
//                                                       @"release_date" : @"releaseDate",
//                                                       @"backdrop_path" : @"backdropPath",
//                                                       @"vote_average" : @"voteAverage",
//                                                       @"vote_count" : @"voteCount",
//                                                       @"runtime": @"runtime",
//                                                       }];
//    
//    // Define the relationship mapping
//    [movieMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"genres"
//                                                                                 toKeyPath:@"genres"
//                                                                               withMapping:genreMapping]];
//    
//    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping
//                                                                                            method:RKRequestMethodAny
//                                                                                       pathPattern:nil
//                                                                                           keyPath:@""
//                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//    
//    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%d?api_key=34aa7e1baaee7e047801a1a8454587b8", [movie.id intValue]]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
//    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//        self.selectedMovies = mappingResult.array;
//        //[self.movieCastCollectionView reloadData];
//        MOVMovie *clickedMovie = [self.selectedMovies objectAtIndex:0];
//        [movie setRuntime:clickedMovie.runtime];
//        [movie setGenres:clickedMovie.genres];
//    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//        NSLog(@"Could not load movie cast from API!': %@", error);
//    }];
//    
//    [objectRequestOperation start];
//    
//}

/*
 * Updates the inputed movie information. It sets the movie videos.
 *
 *
 */
-(void)addMovieVideo:(MOVMovie *)movie {
    
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
    
    // Register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:videoMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"results" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%d/videos?api_key=eeeda4aeb01446fa9cabef99fab242af", [movie.id intValue]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        movie.videos = mappingResult.array;
        NSLog(@"MOVIE VIDEO NUMBER: %lu", [movie.videos count]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Could not load movie cast from API!': %@", error);
    }];
    
    [objectRequestOperation start];

    
}

///*
// * Updates the inputed movie information. It sets the movie runtime and movie genres.
// *
// *
// */
//-(void)addTvShowDurationAndGenres:(MOVTVShow *)tvShow {
//    
//    // Create our new Genre mapping
//    RKObjectMapping *genreMapping = [RKObjectMapping mappingForClass:[MOVGenre class]];
//    
//    [genreMapping addAttributeMappingsFromArray:@[ @"id", @"name" ]];
//    
//    RKObjectMapping *durationMapping = [RKObjectMapping mappingForClass:[MOVDuration class]];
//    
//    // Configuring the Movie mapping
//    RKObjectMapping *tvShowMapping = [RKObjectMapping mappingForClass:[MOVTVShow class]];
//    [tvShowMapping addAttributeMappingsFromDictionary:@{
//                                                       @"id" : @"id",
//                                                       @"name" : @"name",
//                                                       @"overview" : @"overview",
//                                                       @"poster_path" : @"posterPath",
//                                                       @"first_air_date" : @"firstAirDate",
//                                                       @"backdrop_path" : @"backdropPath",
//                                                       @"vote_average" : @"voteAverage",
//                                                       @"vote_count" : @"voteCount"
//                                                       }];
//    
//    // Define the relationship mapping
//    [tvShowMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"genres"
//                                                                                 toKeyPath:@"genres"
//                                                                               withMapping:genreMapping]];
//    
//    [durationMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"duration"]];
//
//    [tvShowMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"episode_run_time"
//                                                                                  toKeyPath:@"episodeRunTime"
//                                                                                withMapping:durationMapping]];
//
//    
//    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:tvShowMapping
//                                                                                            method:RKRequestMethodAny
//                                                                                       pathPattern:nil
//                                                                                           keyPath:@""
//                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//    
//    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.themoviedb.org/3/tv/%d?api_key=34aa7e1baaee7e047801a1a8454587b8", [tvShow.id intValue]]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
//    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//        //self.selectedTvShows = mappingResult.array;
//        //[self.movieCastCollectionView reloadData];
//        MOVTVShow *clickedTvShow = mappingResult.firstObject;
//        [tvShow setGenres:clickedTvShow.genres];
//        [tvShow setEpisodeRunTime:clickedTvShow.episodeRunTime];
//        
//        MOVDuration *tvShowDuration = [clickedTvShow.episodeRunTime objectAtIndex:0];
//        [tvShow setDuration:tvShowDuration.duration];
//        
//    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//        NSLog(@"Could not load movie cast from API!': %@", error);
//    }];
//    
//    [objectRequestOperation start];
//    
//}

/*
 * Updates the inputed tv show information. It sets the tv show videos.
 *
 *
 */
-(void)addTVShowVideo:(MOVTVShow *)tvShow {
    
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
    
    // Register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:videoMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"results" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.themoviedb.org/3/tv/%d/videos?api_key=eeeda4aeb01446fa9cabef99fab242af", [tvShow.id intValue]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        tvShow.videos = mappingResult.array;
        NSLog(@"MOVIE VIDEO NUMBER: %lu", [tvShow.videos count]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Could not load movie cast from API!': %@", error);
    }];
    
    [objectRequestOperation start];
    
    
}


/*
 * Method that converts inputed month and day into string format.
 */
-(NSString *)dateStringFormat:(NSString *)day month:(NSString *)month {
    
    NSString *suffix = nil;
    
    int dayInteger = [day intValue];
    int ones = dayInteger % 10;
    int tens = floor(dayInteger / 10);
    tens = tens % 10;
    
    if (tens == 1) {
        suffix = @"th";
    } else {
        switch (ones) {
            case 1 : suffix = @"st";
                break;
            case 2 : suffix = @"nd";
                break;
            case 3 : suffix = @"rd";
                break;
            default : suffix = @"th";
        }
    }
    NSString *dayString = [NSString stringWithFormat:@"%@%@", day, suffix];
    
    NSArray *months = [[NSArray alloc] initWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
    
    NSString *monthString = [months objectAtIndex:[month intValue] - 1];
    
    NSString *dateString = [NSString stringWithFormat:@"%@ %@", monthString, dayString];
    
    return dateString;
}


-(NSString *)insertMovieDate:(MOVMovie *)movie {
    
    // Release date
    NSString *dateString = movie.releaseDate;
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateMovie = [dateFormater dateFromString:dateString];
    NSDateComponents *movieDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth |   NSCalendarUnitYear fromDate:dateMovie];
    
    NSDateFormatter *currentDateFormater =[[NSDateFormatter alloc] init];
    [currentDateFormater setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateString = [currentDateFormater stringFromDate:[NSDate date]];
    NSDate *currentDate = [currentDateFormater dateFromString:currentDateString];
    NSDateComponents *currentDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth |   NSCalendarUnitYear fromDate:currentDate];

    
    if ([movieDateComponents year] < [currentDateComponents year]) {
        return [NSString stringWithFormat:@"%lu", [movieDateComponents year]];
    } else if (([movieDateComponents year] == [currentDateComponents year]) && ([movieDateComponents month] < [currentDateComponents month])){
        return [NSString stringWithFormat:@"%lu", [movieDateComponents year]];
    } else if (([movieDateComponents year] == [currentDateComponents year]) && ([movieDateComponents month] == [currentDateComponents month]) && ([movieDateComponents day] < [currentDateComponents day])) {
        return [NSString stringWithFormat:@"%lu", [movieDateComponents year]];
    } else if (([movieDateComponents year] == [currentDateComponents year]) && ([movieDateComponents month] == [currentDateComponents month]) && ([movieDateComponents day] == [currentDateComponents day])) {
        return @"Today";
    } else if (([movieDateComponents year] == [currentDateComponents year]) && ([movieDateComponents month] == [currentDateComponents month]) && ([movieDateComponents day] > [currentDateComponents day])) {
        return [self dateStringFormat:[NSString stringWithFormat:@"%lu", [movieDateComponents day]] month:[NSString stringWithFormat:@"%lu", [movieDateComponents month]]];
    } else if (([movieDateComponents year] >= [currentDateComponents year]) && (([movieDateComponents month] - [currentDateComponents month]) == 1)) {
        return @"Next month";
    } else {
        return @"In three months";
    }

}


@end
