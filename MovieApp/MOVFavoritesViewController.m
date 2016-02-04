//
//  MOVFavoritesViewController.m
//  MovieApp
//
//  Created by Adis Cehajic on 2/1/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import "MOVFavoritesViewController.h"
#import "MOVFavoritesTableViewCell.h"
#import "MOVMovieRLM.h"
#import "MOVTVShowRLM.h"
#import <Realm/Realm.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"
#import "MOVConstants.h"
#import "MOVMovieDetailsViewController.h"
#import "MOVHomeTableViewCell.h"
#import "MOVObjectMapping.h"
#import "MOVHelperMethods.h"

@interface MOVFavoritesViewController ()

{
    NSMutableArray *favorites;
    RLMResults *favoritesMovies;
    RLMResults *favoritesTVShows;
}

@end

@implementation MOVFavoritesViewController

static NSString *movieSegue = @"movieDetailsSegue";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Setting the color of the status bar to the white.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.title = @"Favorites";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [favoritesMovies count] + [favoritesTVShows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *favoritesCellIdentifier = @"FavoritesTableCell";
    MOVFavoritesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:favoritesCellIdentifier forIndexPath:indexPath];
    
    
    if ([[favorites objectAtIndex:indexPath.row] isKindOfClass:[MOVMovieRLM class]]) {
        
        MOVMovieRLM *favMovie = [favorites objectAtIndex:indexPath.row];
        
        // Movie image
        NSURL * urlImage = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, IMAGE_SIZE_W92, favMovie.poster_path]];
        [cell.favoritesImage sd_setImageWithURL:urlImage];
        
        cell.favoritesTitle.attributedText = [favMovie setMovieTitleAndYear:favMovie];
        cell.favoritesDuration.text = [MOVHelperMethods convertMinutesIntoHours:favMovie.runtime];
        cell.favoritesRaiting.text = [NSString stringWithFormat:@"%.1f", [favMovie.vote_average floatValue]];
    
    } else {
        
        MOVTVShowRLM *favTVShow = [favorites objectAtIndex:indexPath.row];
        
        // TV show image
        NSURL * urlImage = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, IMAGE_SIZE_W92, favTVShow.poster_path]];
        [cell.favoritesImage sd_setImageWithURL:urlImage];
        
        cell.favoritesTitle.attributedText = [favTVShow setTVShowTitleAndYear:favTVShow];
        cell.favoritesDuration.text = [MOVHelperMethods convertMinutesIntoHours:favTVShow.duration];
        cell.favoritesRaiting.text = [NSString stringWithFormat:@"%.1f", [favTVShow.vote_average floatValue]];
    }
    
    return cell;

        
}

-(void)viewDidAppear:(BOOL)animated {

    favoritesMovies = [MOVMovieRLM allObjects];
    
    favoritesTVShows = [MOVTVShowRLM allObjects];

    favorites = [[NSMutableArray alloc] initWithCapacity:([favoritesMovies count] + [favoritesTVShows count])];
    
    [favorites addObjectsFromArray:(NSArray *)favoritesMovies];
    [favorites addObjectsFromArray:(NSArray *)favoritesTVShows];
    
    [self.favoritesTable reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSIndexPath *indexPath = nil;
    
    if ([segue.identifier isEqualToString:movieSegue]) {
        MOVMovieDetailsViewController *movieDetail = [segue destinationViewController];
        
        indexPath = [self.favoritesTable indexPathForSelectedRow];
        
        if ([[favorites objectAtIndex:indexPath.row] isKindOfClass:[MOVMovieRLM class]]) {
            MOVMovieRLM *movieRLM = [favorites objectAtIndex:indexPath.row];

            MOVMovie *favoriteMovie = [self getMovieFromRealm:movieRLM];
                        
            movieDetail.movie = favoriteMovie;
            movieRLM = nil;
        } else {
            MOVTVShowRLM *tvShowRLM = [favorites objectAtIndex:indexPath.row];

            movieDetail.serie = [self getTVShowFromRealm:tvShowRLM];
        }
    }
}

-(MOVMovie *)getMovieFromRealm:(MOVMovieRLM *)movieRLM {
    
    MOVMovie *movie = [[MOVMovie alloc] init];
    movie.id = movieRLM.id;
    movie.title = movieRLM.title;
    movie.overview = movieRLM.overview;
    movie.posterPath = movieRLM.poster_path;
    movie.releaseDate = movieRLM.release_date;
    movie.backdropPath = movieRLM.backdrop_path;
    movie.voteAverage = movieRLM.vote_average;
    movie.voteCount = movieRLM.vote_count;
    movie.runtime = movieRLM.runtime;
    [movie convertMovieGenres:movieRLM.genres];
    
    return movie;
}

-(MOVTVShow *)getTVShowFromRealm:(MOVTVShowRLM *)tvShowRLM {
    
    MOVTVShow *tvShow = [[MOVTVShow alloc] init];
    
    tvShow.id = tvShowRLM.id;
    tvShow.name = tvShowRLM.name;
    tvShow.overview = tvShowRLM.overview;
    tvShow.posterPath = tvShowRLM.poster_path;
    tvShow.firstAirDate = tvShowRLM.first_air_date;
    tvShow.backdropPath = tvShowRLM.backdrop_path;
    tvShow.voteAverage = tvShowRLM.vote_average;
    tvShow.voteCount = tvShowRLM.vote_count;
    [tvShow convertTVShowGenres:tvShowRLM.genres];
    tvShow.duration = tvShowRLM.duration;
    
    return tvShow;
    
}


@end
