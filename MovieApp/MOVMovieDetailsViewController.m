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
#import "MOVConstants.h"
#import "MOVHelperMethods.h"
#import "MOVActorMovie.h"
#import "MOVObjectMapping.h"

@interface MOVMovieDetailsViewController ()

{
    RLMResults *savedMovies;
    RLMResults *realmMovie;
    RLMResults *realmTvShow;
}

@end

@implementation MOVMovieDetailsViewController

static NSString * const reuseIdentifier = @"MovieActorCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleDone target:self action:@selector(homeScreen:)];
//    
//    self.navigationItem.rightBarButtonItem = homeButton;
    
    // Clears all from Realm DB.
    [[NSFileManager defaultManager] removeItemAtPath:[[RLMRealmConfiguration defaultConfiguration] path] error:nil];
    
    [self checkIfTheMovieIsFavorite];
    
    // Checking if the selected object from categories is movie or tv show.
    if ([self.movie isKindOfClass:[MOVMovie class]]) {
        
        self.movieDescription.text = self.movie.overview;
    
        // Checking does the movie has the image.
        if (self.movie.posterPath != nil) {
            
            // Movie image
            NSURL * urlImage = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, IMAGE_SIZE_W92, self.movie.posterPath]];
            [self.movieImage sd_setImageWithURL:urlImage];
        
        } else {
            
            UIImage *movImage = [UIImage imageNamed:@"movie_placeholder.png"];
            self.movieImage.image = movImage;

        }
        
        // Checking does the movie has the poster.
        if (self.movie.backdropPath != nil) {
            
            // Movie poster
            NSURL * urlPoster = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, POSTER_SIZE_W1280, self.movie.backdropPath]];
            [self.moviePoster sd_setImageWithURL:urlPoster];
        
        } else {
            
            UIImage *movPoster = [UIImage imageNamed:@"movieposter_placeholder1.png"];
            self.moviePoster.image = movPoster;
            
        }
        
        // Setting the name of the movie and the year of the movie with different fonts.
        self.movieTitle.attributedText = (NSAttributedString *)[self.movie setMovieTitleAndYear:self.movie];
        
        // Setting the average movie rating and number of votes.
        self.movieVoteAverage.text = [NSString stringWithFormat:@"%.1f", [self.movie.voteAverage floatValue]];
        self.movieVoteCount.text = self.movie.voteCount;
        
        // Setting the navbar title.
        self.title = self.movie.title;
        
        // Checking does the movie has genres.
        if ([self.movie.genres count] > 0) {
            
            // Setting the genres of the movie
            MOVGenre *durationGenre = [self.movie.genres objectAtIndex:0];
            self.movieDurationGenre.text = durationGenre.name;
            
            for (int i = 1; i < [self.movie.genres count]; i++) {
                durationGenre = [self.movie.genres objectAtIndex:i];
                self.movieDurationGenre.text = [self.movieDurationGenre.text stringByAppendingString:[NSString stringWithFormat:@" | %@", durationGenre.name]];
            }
        }
        
        // Setting the duration of the movie.
        self.movieDurationGenre.text = [NSString stringWithFormat:@"%@ - %@", [MOVHelperMethods convertMinutesIntoHours:self.movie.runtime], self.movieDurationGenre.text];
        
        if ([self.movie.videos count] > 0) {
            [self.videoButton setEnabled:YES];
        }
        
        [self loadMovieCast:self.movie.id];
    } else {
        
        self.movieDescription.text = self.serie.overview;
        
        // Checking does the tv show has image.
        if (self.serie.posterPath != nil) {
            
            // Tv show image
            NSURL * urlImage = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, IMAGE_SIZE_W92, self.serie.posterPath]];
            [self.movieImage sd_setImageWithURL:urlImage];
        
        } else {
            
            UIImage *tvImage = [UIImage imageNamed:@"movie_placeholder.png"];
            self.movieImage.image = tvImage;
            
        }
        
        // Checking does the tv show has poster.
        if (self.serie.backdropPath != nil) {
            
            // Tv show poster
            NSURL * urlPoster = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, POSTER_SIZE_W1280, self.serie.backdropPath]];
            [self.moviePoster sd_setImageWithURL:urlPoster];
        
        } else {
            
            UIImage *tvPoster = [UIImage imageNamed:@"movieposter_placeholder1.png"];
            self.moviePoster.image = tvPoster;
            
        }

        
        // Setting the name of the tv show and the year of the tv show with different fonts.
        self.movieTitle.attributedText = [self.serie setTVShowTitleAndYear:self.serie];
        
        // Setting the average tv show rating and number of votes.
        self.movieVoteAverage.text = [NSString stringWithFormat:@"%.1f", [self.serie.voteAverage floatValue]];
        self.movieVoteCount.text = self.serie.voteCount;
        
        // Setting the navbar title.
        self.title = self.serie.name;
        
        // Checking does the tv show has genres.
        if ([self.serie.genres count] > 0) {
            
            // Setting the tv show duration and tv show genre.
            MOVGenre *durationGenre = [self.serie.genres objectAtIndex:0];
            self.movieDurationGenre.text = durationGenre.name;
            
            // Setting the genres of the tv show.
            for (int i = 1; i < [self.serie.genres count]; i++) {
                durationGenre = [self.serie.genres objectAtIndex:i];
                self.movieDurationGenre.text = [self.movieDurationGenre.text stringByAppendingString:[NSString stringWithFormat:@" | %@", durationGenre.name]];
            }
        }
        
//        MOVDuration *serieDuration = [self.serie.episodeRunTime objectAtIndex:0];

        // Setting the duration of the tv show.
        self.movieDurationGenre.text = [NSString stringWithFormat:@"%@ - %@", [MOVHelperMethods convertMinutesIntoHours:self.serie.duration], self.movieDurationGenre.text];
    
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
                                                      @"cast_id": @"castId",
                                                      @"character": @"character",
                                                      @"credit_id": @"creditId",
                                                      @"id": @"id",
                                                      @"name" : @"name",
                                                      @"order" : @"order",
                                                      @"profile_path" : @"profilePath"
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
                                                      @"credit_id": @"creditId",
                                                      @"id": @"id",
                                                      @"name" : @"name",
                                                      @"order" : @"order",
                                                      @"profile_path" : @"profilePath"
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
    
        if (movieActor.profilePath != nil) {
            NSURL *urlImage = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, IMAGE_SIZE_W92, movieActor.profilePath]];
            [cell.movieActorImage sd_setImageWithURL:urlImage];
        } else {
            UIImage *actorImage = [UIImage imageNamed:@"movieperson_placeholder.png"];
            cell.movieActorImage.image = actorImage;
        }
        
    } else {
        
        MOVTVShowCast *tvShowActor = [self.movieCast objectAtIndex:indexPath.row];

        cell.movieActorName.text = tvShowActor.name;
        
        if (tvShowActor.profilePath != nil) {
            NSURL *urlImage = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, IMAGE_SIZE_W92, tvShowActor.profilePath]];
            [cell.movieActorImage sd_setImageWithURL:urlImage];
        } else {
            UIImage *actorImage = [UIImage imageNamed:@"movieperson_placeholder.png"];
            cell.movieActorImage.image = actorImage;
        }
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
            actorController.moviePoster = self.movie.backdropPath;
        } else {
            actorController.moviePoster = self.serie.backdropPath;
        }
    }
    // Finds the trailer video from the seleted movie or tv show and opens it into the new view controller.
    if ([segue.identifier isEqualToString:@"movieVideoSegue"]) {
        
        MOVVideo *firstMovieVideo = nil;
        NSString *videoKey = nil;
        
        if ([self.movie.videos count] > 0) {
            firstMovieVideo = [self.movie.videos objectAtIndex:0];
            videoKey = firstMovieVideo.key;
            
            MOVVideoViewController *videoController = [segue destinationViewController];
            
            videoController.videoUrl = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", videoKey];
        } else if([self.serie.videos count] > 0) {
            firstMovieVideo = [self.serie.videos objectAtIndex:0];
            videoKey = firstMovieVideo.key;
        
            MOVVideoViewController *videoController = [segue destinationViewController];
            
            videoController.videoUrl = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", videoKey];
        } else {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No available videos" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
        }
    }

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
            movieRLM.poster_path = self.movie.posterPath;
            movieRLM.release_date = self.movie.releaseDate;
            movieRLM.backdrop_path = self.movie.backdropPath;
            movieRLM.vote_average = self.movie.voteAverage;
            movieRLM.vote_count = self.movie.voteCount;
            movieRLM.runtime = self.movie.runtime;
            [movieRLM convertMovieGenres:self.movie.genres];
            [realm addObject:movieRLM];
            [realm commitWriteTransaction];
        
            [MOVHelperMethods changeFavoriteButtonState:@"liked.png" favoriteButton:self.favoritesButton];
            
        } else {
            // Delete the movie information from database.
            [[RLMRealm defaultRealm] beginWriteTransaction];
            [[RLMRealm defaultRealm]deleteObject:[realmMovie firstObject]];
            [[RLMRealm defaultRealm] commitWriteTransaction];

            [MOVHelperMethods changeFavoriteButtonState:@"like_white.png" favoriteButton:self.favoritesButton];

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
            tvShowRLM.poster_path = self.serie.posterPath;
            tvShowRLM.first_air_date = self.serie.firstAirDate;
            tvShowRLM.backdrop_path = self.serie.backdropPath;
            tvShowRLM.vote_average = self.serie.voteAverage;
            tvShowRLM.vote_count = self.serie.voteCount;
            tvShowRLM.duration = self.serie.duration;
            [tvShowRLM convertTVShowGenres:self.serie.genres];
            [realm addObject:tvShowRLM];
            [realm commitWriteTransaction];
            
            [MOVHelperMethods changeFavoriteButtonState:@"liked.png" favoriteButton:self.favoritesButton];
            
        } else {
            // Deleting the tv show from database.
            [[RLMRealm defaultRealm] beginWriteTransaction];
            [[RLMRealm defaultRealm]deleteObject:[realmTvShow firstObject]];
            [[RLMRealm defaultRealm] commitWriteTransaction];
            
            [MOVHelperMethods changeFavoriteButtonState:@"like_white.png" favoriteButton:self.favoritesButton];
            
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
            [MOVHelperMethods changeFavoriteButtonState:@"liked.png" favoriteButton:self.favoritesButton];
        }
    } else {
        
        realmTvShow = [MOVTVShowRLM objectsWhere:@"id = %@", self.serie.id];
        
        if ([realmTvShow count] > 0) {
            [MOVHelperMethods changeFavoriteButtonState:@"liked.png" favoriteButton:self.favoritesButton];
        }
    }
}

//- (void)loadView {
//    // create and configure the scrollview
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    self.view = scrollView;
//}

@end
