//
//  MOVHomeTableViewController.m
//  MovieApp
//
//  Created by Adis Cehajic on 20/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import "MOVHomeTableViewController.h"
#import "MOVHomeTableViewCell.h"
#import "MOVMovie.h"
#import "MOVTVShow.h"
#import <RestKit/RestKit.h>
#import "MOVCollectionViewCell.h"
#import "MOVMovieDetailsViewController.h"
#import "MOVHomeTableViewCell.h"
#import "MOVMovieCast.h"
#import "MOVConstants.h"

@interface MOVHomeTableViewController ()

{
    NSMutableArray *categories;
    NSMutableDictionary *movies;
}

@end

@implementation MOVHomeTableViewController

static NSString *tableCellIdentifier = @"TableCell";
static NSString *movieSegue = @"movieDetailsSegue";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    categories = [[NSMutableArray alloc] initWithObjects:@"Most popular movies", @"Top rated movies", @"Upcoming movies", @"Top rated TV shows", @"Most popular TV shows", nil];

    movies = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    self.topRatedMovies = [[NSMutableArray alloc] init];
    self.popularMovies = [[NSMutableArray alloc] init];
    self.upcomingMovies = [[NSMutableArray alloc] init];
    self.popularSeries = [[NSMutableArray alloc] init];
    self.topRatedSeries = [[NSMutableArray alloc] init];
    
    
    // Setting the color of the status bar to the white.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    // Calling methods for mapping.
    [self configureRestKit];
    [self loadMoviesAndSeries];

}

/*
 * Maps the movie and tv show object and connects them to the url path of the API.
 */
- (void)configureRestKit{
    
    // Initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:URL_BASE];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // Initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    
    // Setup object mappings for movies.
    RKObjectMapping *movieMapping = [RKObjectMapping mappingForClass:[MOVMovie class]];
    [movieMapping addAttributeMappingsFromArray:@[@"id", @"title", @"overview", @"poster_path", @"release_date", @"backdrop_path", @"vote_average", @"vote_count"]];
    
    // Register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptorTopRatedMovies = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping method:RKRequestMethodGET pathPattern:nil keyPath:@"results" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptorTopRatedMovies];

    RKResponseDescriptor *responseDescriptorPopularMovies = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping method:RKRequestMethodGET pathPattern:nil keyPath:@"results" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptorPopularMovies];
    
    RKResponseDescriptor *responseDescriptorUpcomingMovies = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping method:RKRequestMethodGET pathPattern:nil keyPath:@"results" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptorUpcomingMovies];

    
    // Setup object mappings for tv shows.
    RKObjectMapping *seriesMapping = [RKObjectMapping mappingForClass:[MOVTVShow class]];
    [seriesMapping addAttributeMappingsFromArray:@[@"id", @"name", @"overview", @"poster_path", @"first_air_date", @"backdrop_path", @"vote_average", @"vote_count"]];
    
    RKResponseDescriptor *responseDescriptorTopRatedSeries = [RKResponseDescriptor responseDescriptorWithMapping:seriesMapping method:RKRequestMethodGET pathPattern:TOP_RATED_TV_SHOWS_URL keyPath:@"results" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptorTopRatedSeries];
    
    RKResponseDescriptor *responseDescriptorPopularSeries = [RKResponseDescriptor responseDescriptorWithMapping:seriesMapping method:RKRequestMethodGET pathPattern:POPULAR_TV_SHOWS_URL keyPath:@"results" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptorPopularSeries];
    
}

/*
 * Connects the movie and tv show models with API and stores the results into array.
 */
- (void) loadMoviesAndSeries {
    
    NSDictionary *queryParams = @{@"api_key" : API_KEY};
    
    [self mapMoviesFromAPI:POPULAR_MOVIES_URL parameters:queryParams moviesArray:self.popularMovies moviesKey:[categories objectAtIndex:0]];
    [self mapMoviesFromAPI:TOP_RATED_MOVIES_URL parameters:queryParams moviesArray:self.topRatedMovies moviesKey:[categories objectAtIndex:1]];
    [self mapMoviesFromAPI:UPCOMING_MOVIES_URL parameters:queryParams moviesArray:self.upcomingMovies moviesKey:[categories objectAtIndex:2]];
    [self mapMoviesFromAPI:TOP_RATED_TV_SHOWS_URL parameters:queryParams moviesArray:self.topRatedSeries moviesKey:[categories objectAtIndex:3]];
    [self mapMoviesFromAPI:POPULAR_TV_SHOWS_URL parameters:queryParams moviesArray:self.popularSeries moviesKey:[categories objectAtIndex:4]];
    
//    [[RKObjectManager sharedManager] getObjectsAtPath:TOP_RATED_MOVIES_URL parameters:queryParams
//                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                                                  self.topRatedMovies = mappingResult.array;
//                                                  NSLog(@"TOP RATED MOVIES: %lu", [self.topRatedMovies count]);
//                                                  [movies setObject:self.topRatedMovies forKey:@"Top rated movies"];
//                                                  [self.tableView reloadData];
//                                              }
//                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
//                                                  NSLog(@"Could not load movies from API!': %@", error);
//                                              }];
//    [[RKObjectManager sharedManager] getObjectsAtPath:POPULAR_MOVIES_URL parameters:queryParams
//                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                                                  self.popularMovies = mappingResult.array;
//                                                  NSLog(@"TOP RATED MOVIES: %lu", [self.popularMovies count]);
//                                                  [movies setObject:self.popularMovies forKey:@"Most popular movies"];
//                                                  [self.tableView reloadData];
//                                              }
//                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
//                                                  NSLog(@"Could not load movies from API!': %@", error);
//                                              }];
//    [[RKObjectManager sharedManager] getObjectsAtPath:UPCOMING_MOVIES_URL parameters:queryParams
//                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                                                  self.upcomingMovies = mappingResult.array;
//                                                  NSLog(@"TOP RATED MOVIES: %lu", [self.upcomingMovies count]);
//                                                  [movies setObject:self.upcomingMovies forKey:@"Upcoming movies"];
//                                                  [self.tableView reloadData];
//                                              }
//                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
//                                                  NSLog(@"Could not load movies from API!': %@", error);
//                                              }];
//
//    [[RKObjectManager sharedManager] getObjectsAtPath:TOP_RATED_TV_SHOWS_URL parameters:queryParams
//                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                                                  self.topRatedSeries = mappingResult.array;
//                                                  [movies setObject:self.topRatedSeries forKey:@"Top rated TV shows"];
//                                                  [self.tableView reloadData];
//                                              }
//                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
//                                                  NSLog(@"Could not load movies from API!': %@", error);
//                                              }];
//    [[RKObjectManager sharedManager] getObjectsAtPath:POPULAR_TV_SHOWS_URL parameters:queryParams
//                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                                                  self.popularSeries = mappingResult.array;
//                                                  [movies setObject:self.popularSeries forKey:@"Most popular TV shows"];
//                                                  [self.tableView reloadData];
//                                              }
//                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
//                                                  NSLog(@"Could not load movies from API!': %@", error);
//                                              }];
}


-(void)mapMoviesFromAPI:(NSString *)urlPath parameters:(NSDictionary *)queryParams moviesArray:(NSMutableArray *)moviesCategory moviesKey:(NSString *)moviesKey {
    
    void(^movieBlock)(NSMutableArray *, NSArray *) = ^(NSMutableArray * movieArray, NSArray * apiArray)
    {
        [movieArray addObjectsFromArray:apiArray];
    };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:urlPath parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  movieBlock(moviesCategory, mappingResult.array);
                                                  
                                                  [movies setObject:moviesCategory forKey:moviesKey];
                                                  
                                                  [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Could not load movies from API!': %@", error);
                                              }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [movies count] ? [movies count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MOVHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier forIndexPath:indexPath];
    
    cell.categoryTitle.text = [categories objectAtIndex:indexPath.row];
    cell.delegate = self;

    cell.movies = [movies objectForKey:[categories objectAtIndex:indexPath.row]];
    
    [cell.movieCollectionView reloadData];
    
    return cell;
}

/*
 * Adds the segue for selected collection cell that contains movie.
 */
-(void) addSegueMovie:(MOVMovie *)movie {
    self.selectedMovie = movie;
    [self performSegueWithIdentifier:movieSegue sender:self];
    
}

/*
 * Adds the segue for selected collection cell that contains tv show.
 */
-(void) addSegueSerie:(MOVTVShow *)serie {
    self.selectedSerie = serie;
    
    [self performSegueWithIdentifier:movieSegue sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:movieSegue]) {
        MOVMovieDetailsViewController *movieDetail = [segue destinationViewController];
        
        if (self.selectedMovie != nil) {
            movieDetail.movie = self.selectedMovie;
            self.selectedMovie = nil;
        } else {
            movieDetail.serie = self.selectedSerie;
        }
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end