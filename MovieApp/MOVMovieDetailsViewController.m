//
//  MOVMovieDetailsViewController.m
//  MovieApp
//
//  Created by Adis Cehajic on 24/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import "MOVMovieDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"
#import "MOVMovie.h"
#import "MOVTVShow.h"
#import "MOVMovieActorCollectionViewCell.h"
#import <RestKit/RestKit.h>
#import "MOVMovieCast.h"
#import "MOVTVShowCast.h"
#import "MOVDuration.h"
#import "MOVActorDetailsViewController.h"
#import "MOVVideoViewController.h"
#import "MOVVideo.h"
#import "MOVMovieRLM.h"
#import "MOVTVShowRLM.h"
#import <Realm/Realm.h>



@interface MOVMovieDetailsViewController ()

{
    RLMResults *savedMovies;
    RLMResults *realmMovie;
    RLMResults *realmTvShow;

}

@end

@implementation MOVMovieDetailsViewController

static NSString * const URL_BASE_IMG = @"http://image.tmdb.org/t/p/";
static NSString * const POSTER_SIZE_W720 = @"w1280";
static NSString * const IMAGE_SIZE_W92 = @"w92";
static NSString * const reuseIdentifier = @"MovieActorCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkIfTheMovieIsFavorite];
    
    // Checking if the selected object from categories is movie or tv show.
    if ([self.movie isKindOfClass:[MOVMovie class]]) {
        
        NSLog(@"==================MOVIE ID: %@", self.movie.id);

        self.movieDescription.text = self.movie.overview;
    
        // Movie image
        NSURL * urlImage = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, IMAGE_SIZE_W92, self.movie.poster_path]];
        [self.movieImage sd_setImageWithURL:urlImage];
        // Movie poster
        NSURL * urlPoster = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, POSTER_SIZE_W720, self.movie.backdrop_path]];
        [self.moviePoster sd_setImageWithURL:urlPoster];
        
        // Release date
        NSString *dateString = self.movie.release_date;
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormater dateFromString:dateString];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
        // Setting the name of the movie and the year of the movie with different fonts.
        UIFont *helveticaFontTitle = [UIFont fontWithName:@"helvetica neue" size:17.0];
        UIFont *helveticaFontYear = [UIFont fontWithName:@"helvetica neue" size:13.0];

        NSDictionary *helveticaDictTitle = [NSDictionary dictionaryWithObject: helveticaFontTitle forKey:NSFontAttributeName];
        NSMutableAttributedString *movieTitleString = [[NSMutableAttributedString alloc] initWithString:self.movie.title attributes: helveticaDictTitle];
        
        NSDictionary *helveticaDictYear = [NSDictionary dictionaryWithObject:helveticaFontYear forKey:NSFontAttributeName];
        NSMutableAttributedString *movieYearString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" (%lu)", [components year]] attributes:helveticaDictYear];
        
        [movieTitleString appendAttributedString:movieYearString];
        
        self.movieTitle.attributedText = movieTitleString;
        
        self.movieVoteAverage.text = [NSString stringWithFormat:@"%.1f", [self.movie.vote_average floatValue]];
        self.movieVoteCount.text = self.movie.vote_count;
        
        // Setting the navbar title.
        self.title = self.movie.title;
        
        // Setting the movie duration and movie genre.
        MOVGenre *durationGenre = [self.movie.genres objectAtIndex:0];
        self.movieDurationGenre.text = durationGenre.name;
        
        for (int i = 1; i < [self.movie.genres count]; i++) {
            durationGenre = [self.movie.genres objectAtIndex:i];
            self.movieDurationGenre.text = [self.movieDurationGenre.text stringByAppendingString:[NSString stringWithFormat:@" | %@", durationGenre.name]];
        }
        
        self.movieDurationGenre.text = [NSString stringWithFormat:@"%@ - %@", [self convertMinutesIntoHours:self.movie.runtime], self.movieDurationGenre.text];
        
        [self loadMovieCast:self.movie.id];
    } else {
        
        NSLog(@"==================SERIE ID: %@", self.serie.id);
        
        self.movieDescription.text = self.serie.overview;
        
        // Movie image
        NSURL * urlImage = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, IMAGE_SIZE_W92, self.serie.poster_path]];
        [self.movieImage sd_setImageWithURL:urlImage];
        // Movie poster
        NSURL * urlPoster = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, POSTER_SIZE_W720, self.serie.backdrop_path]];
        [self.moviePoster sd_setImageWithURL:urlPoster];
                
        // Release date
        NSString *dateString = self.serie.first_air_date;
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormater dateFromString:dateString];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];

        // Setting the name of the tv show and the year of the tv show with different fonts.
        UIFont *helveticaFontTitle = [UIFont fontWithName:@"helvetica neue" size:17.0];
        UIFont *helveticaFontYear = [UIFont fontWithName:@"helvetica neue" size:13.0];
        
        NSDictionary *helveticaDictTitle = [NSDictionary dictionaryWithObject: helveticaFontTitle forKey:NSFontAttributeName];
        NSMutableAttributedString *movieTitleString = [[NSMutableAttributedString alloc] initWithString:self.serie.name attributes: helveticaDictTitle];
        
        NSDictionary *helveticaDictYear = [NSDictionary dictionaryWithObject:helveticaFontYear forKey:NSFontAttributeName];
        NSMutableAttributedString *movieYearString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" (%lu)", [components year]] attributes:helveticaDictYear];
        
        [movieTitleString appendAttributedString:movieYearString];
        
        self.movieTitle.attributedText = movieTitleString;
        
        self.movieVoteAverage.text = [NSString stringWithFormat:@"%.1f", [self.serie.vote_average floatValue]];
        self.movieVoteCount.text = self.serie.vote_count;
        
        // Setting the navbar title.
        self.title = self.serie.name;
        
        // Setting the tv show duration and tv show genre.
        MOVGenre *durationGenre = [self.serie.genres objectAtIndex:0];
        MOVDuration *serieDuration = [self.serie.episode_run_time objectAtIndex:0];
        self.movieDurationGenre.text = durationGenre.name;
        
        for (int i = 1; i < [self.serie.genres count]; i++) {
            durationGenre = [self.serie.genres objectAtIndex:i];
            self.movieDurationGenre.text = [self.movieDurationGenre.text stringByAppendingString:[NSString stringWithFormat:@" | %@", durationGenre.name]];
        }
        
        self.movieDurationGenre.text = [NSString stringWithFormat:@"%@ - %@", [self convertMinutesIntoHours:serieDuration.duration], self.movieDurationGenre.text];
    
        [self loadTVShowCast:self.serie.id];
    }
}

/*
 *
 */
- (void)loadMovieCast:(NSString *)movieId{
    
    // Setup object mappings for movies
    RKObjectMapping *castMapping = [RKObjectMapping mappingForClass:[MOVMovieCast class]];
    [castMapping addAttributeMappingsFromDictionary:@{
                                                      @"cast_id": @"cast_id",
                                                      @"character": @"character",
                                                      @"credit_id": @"credit_id",
                                                      @"id": @"id",
                                                      @"name" : @"name",
                                                      @"order" : @"order",
                                                      @"profile_path" : @"profile_path"
                                                      }];
    
    // Register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:castMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"cast" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%d/credits?api_key=eeeda4aeb01446fa9cabef99fab242af", [movieId intValue]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.movieCast = mappingResult.array;
        [self.movieCastCollectionView reloadData];
        NSLog(@"MOVIE CAST NUMBER: %lu", [self.movieCast count]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Could not load movie cast from API!': %@", error);
    }];
    
    [objectRequestOperation start];
    
    
}

- (void)loadTVShowCast:(NSString *)tvShowId{
    
    // Setup object mappings for movies
    RKObjectMapping *castMapping = [RKObjectMapping mappingForClass:[MOVTVShowCast class]];
    [castMapping addAttributeMappingsFromDictionary:@{
                                                      @"character": @"character",
                                                      @"credit_id": @"credit_id",
                                                      @"id": @"id",
                                                      @"name" : @"name",
                                                      @"order" : @"order",
                                                      @"profile_path" : @"profile_path"
                                                      }];
    
    // Register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:castMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"cast" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.themoviedb.org/3/tv/%d/credits?api_key=eeeda4aeb01446fa9cabef99fab242af", [tvShowId intValue]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.movieCast = mappingResult.array;
        [self.movieCastCollectionView reloadData];
        NSLog(@"MOVIE CAST NUMBER: %lu", [self.movieCast count]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Could not load movie cast from API!': %@", error);
    }];
    
    [objectRequestOperation start];
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ([self.movieCast count] > 10) ? 10 : [self.movieCast count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MOVMovieActorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if ([[self.movieCast objectAtIndex:indexPath.row] isKindOfClass:[MOVMovieCast class]]) {
        
        MOVMovieCast *movieActor = [self.movieCast objectAtIndex:indexPath.row];
        cell.movieActorName.text = movieActor.name;
    
        NSURL *urlImage = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, IMAGE_SIZE_W92, movieActor.profile_path]];
        [cell.movieActorImage sd_setImageWithURL:urlImage];
        
    } else {
        
        MOVTVShowCast *tvShowActor = [self.movieCast objectAtIndex:indexPath.row];

        cell.movieActorName.text = tvShowActor.name;
        
        NSURL *urlImage = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, IMAGE_SIZE_W92, tvShowActor.profile_path]];
        [cell.movieActorImage sd_setImageWithURL:urlImage];
    }
    
    cell.movieActorImage.layer.cornerRadius = 5;
    cell.movieActorImage.layer.masksToBounds = YES;
    
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Finding which object is selected.
    NSIndexPath *indexPath = [[self.movieCastCollectionView indexPathsForSelectedItems] lastObject];
    MOVMovieCast *movieActor = [self.movieCast objectAtIndex:indexPath.row];
    self.actorId = movieActor.id;
    
    // Passing the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"actorDetailsSegue"]) {

        MOVActorDetailsViewController *actorController = [segue destinationViewController];

        // Setting the actorId variable value from new view controller.
        actorController.actorId = self.actorId;
        
        // Checking if the selected object is movie or tv show and setting the variable that contains the poster image url.
        if (self.movie != nil) {
            actorController.moviePoster = self.movie.backdrop_path;
        } else {
            actorController.moviePoster = self.serie.backdrop_path;
        }
    }
    // Finds the trailer video from the seleted movie or tv show and opens it into the new view controller.
    if ([segue.identifier isEqualToString:@"movieVideoSegue"]) {
        
        
        MOVVideo *firstMovieVideo = nil;
        NSString *videoKey = nil;
        
        if (self.movie != nil) {
            firstMovieVideo = [self.movie.videos objectAtIndex:0];
            videoKey = firstMovieVideo.key;
        } else {
            firstMovieVideo = [self.serie.videos objectAtIndex:0];
            videoKey = firstMovieVideo.key;
        }
        
        MOVVideoViewController *videoController = [segue destinationViewController];
        
        videoController.videoUrl = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", videoKey];
   
    }

}

-(NSString *)convertMinutesIntoHours:(NSString *)amount {
    
    int minutesAmount = [amount intValue];
    
    NSInteger hours = minutesAmount / 60;
    NSInteger minutes = minutesAmount % 60;
    
    if (hours > 0) {
        return [NSString stringWithFormat:@"%ldh %ldm", hours, minutes];
    }
    
    return [NSString stringWithFormat:@"%ldm", minutes];
}

/*
 * Saves the information about opened movie or tv show into database and changes the image of the clicked favorite button.
 * If the movie or tv show is already favorite movie or tv show, it changes the favorite button image to transparent image, 
 * and if the movie or tv show is not in favorites it changes the favorite button image to red image.
 */
-(void)addToFavorites {
    
    if ([self.movie isKindOfClass:[MOVMovie class]]) {

        realmMovie = [MOVMovieRLM objectsWhere:@"id = %@", self.movie.id];

        if ([realmMovie count] == 0) {
        
            // Saving the movie into database.
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            MOVMovieRLM *movieRLM = [[MOVMovieRLM alloc] init];
            movieRLM.id = self.movie.id;
            movieRLM.title = self.movie.title;
            movieRLM.overview = self.movie.overview;
            movieRLM.poster_path = self.movie.poster_path;
            movieRLM.release_date = self.movie.release_date;
            movieRLM.backdrop_path = self.movie.backdrop_path;
            movieRLM.vote_average = self.movie.vote_average;
            movieRLM.vote_count = self.movie.vote_count;
            [realm addObject:movieRLM];
            [realm commitWriteTransaction];
        
            [self changeFavoriteButtonState:@"liked.png"];
            
        } else {
            // Delete the movie information from database.
            [[RLMRealm defaultRealm] beginWriteTransaction];
            [[RLMRealm defaultRealm]deleteObject:[realmMovie firstObject]];
            [[RLMRealm defaultRealm] commitWriteTransaction];

            [self changeFavoriteButtonState:@"notliked.png"];

        }
    } else {
        
        realmTvShow = [MOVTVShowRLM objectsWhere:@"id = %@", self.serie.id];

        if ([realmTvShow count] == 0) {
            
            // Saving the tv show into database.
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            MOVTVShowRLM *tvShowRLM = [[MOVTVShowRLM alloc] init];
            tvShowRLM.id = self.serie.id;
            tvShowRLM.name = self.serie.name;
            tvShowRLM.overview = self.serie.overview;
            tvShowRLM.poster_path = self.serie.poster_path;
            tvShowRLM.first_air_date = self.serie.first_air_date;
            tvShowRLM.backdrop_path = self.serie.backdrop_path;
            tvShowRLM.vote_average = self.serie.vote_average;
            tvShowRLM.vote_count = self.serie.vote_count;
            [realm addObject:tvShowRLM];
            [realm commitWriteTransaction];
            
            [self changeFavoriteButtonState:@"liked.png"];
            
        } else {
            // Deleting the tv show from database.
            [[RLMRealm defaultRealm] beginWriteTransaction];
            [[RLMRealm defaultRealm]deleteObject:[realmTvShow firstObject]];
            [[RLMRealm defaultRealm] commitWriteTransaction];
            
            [self changeFavoriteButtonState:@"notliked.png"];
            
        }
    }

    
}

/*
 * First checks if the selected object is movie or tv show and then checks if the database contains the object with selected id 
 * and sets the favorite button image according with the database state.
 */
-(void)checkIfTheMovieIsFavorite {
    
    if ([self.movie isKindOfClass:[MOVMovie class]]) {
        
        realmMovie = [MOVMovieRLM objectsWhere:@"id = %@", self.movie.id];
        
        if ([realmMovie count] > 0) {
            [self changeFavoriteButtonState:@"liked.png"];
        }
    } else {
        
        realmTvShow = [MOVTVShowRLM objectsWhere:@"id = %@", self.serie.id];
        
        if ([realmTvShow count] > 0) {
            [self changeFavoriteButtonState:@"liked.png"];
        }
    }
}

/*
 * Sets the image of the favorite button to the inputed image.
 */
-(void)changeFavoriteButtonState:(NSString *)imageName {
    UIImage *btnImage = [UIImage imageNamed:imageName];
    [self.favoritesButton setImage:btnImage forState:UIControlStateNormal];
}

//- (void)loadView {
//    // create and configure the scrollview
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    self.view = scrollView;
//}

@end
