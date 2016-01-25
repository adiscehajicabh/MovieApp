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

@interface MOVHomeTableViewController ()

{
    NSMutableArray *categories;
    NSMutableDictionary *movies;
}

@property (nonatomic, strong) NSArray *topRatedMovies;
@property (nonatomic, strong) NSArray *popularMovies;
@property (nonatomic, strong) NSArray *upcomingMovies;
@property (nonatomic, strong) NSArray *topRatedSeries;
@property (nonatomic, strong) NSArray *popularSeries;
@property (nonatomic, strong) MOVMovie *selectedMovie;

@end

@implementation MOVHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    categories = [[NSMutableArray alloc] initWithObjects:@"Most popular movies", @"Top rated movies", @"Upcoming movies", @"Top rated TV shows", @"Most popular TV shows", nil];

    movies = [[NSMutableDictionary alloc] initWithCapacity:5];
    //Add lines for RestKit
    [self configureRestKit];
    [self loadMoviesAndSeries];
    
}

- (void)configureRestKit{
    
    // Initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // Initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // Setup object mappings for movies
    RKObjectMapping *movieMapping = [RKObjectMapping mappingForClass:[MOVMovie class]];
    [movieMapping addAttributeMappingsFromArray:@[@"title", @"overview", @"poster_path", @"release_date", @"backdrop_path", @"vote_average", @"vote_count"]];
    
    // Register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptorTopRatedMovies = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping method:RKRequestMethodGET pathPattern:@"/3/movie/top_rated" keyPath:@"results" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptorTopRatedMovies];

    RKResponseDescriptor *responseDescriptorPopularMovies = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping method:RKRequestMethodGET pathPattern:@"/3/movie/popular" keyPath:@"results" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptorPopularMovies];
    
    RKResponseDescriptor *responseDescriptorUpcomingMovies = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping method:RKRequestMethodGET pathPattern:@"/3/movie/upcoming" keyPath:@"results" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptorUpcomingMovies];

    // Setup object mappings for series
    RKObjectMapping *seriesMapping = [RKObjectMapping mappingForClass:[MOVTVShow class]];
    [seriesMapping addAttributeMappingsFromArray:@[@"name", @"overview", @"poster_path", @"first_air_date"]];
    
    RKResponseDescriptor *responseDescriptorTopRatedSeries = [RKResponseDescriptor responseDescriptorWithMapping:seriesMapping method:RKRequestMethodGET pathPattern:@"/3/tv/top_rated" keyPath:@"results" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptorTopRatedSeries];
    
    RKResponseDescriptor *responseDescriptorPopularSeries = [RKResponseDescriptor responseDescriptorWithMapping:seriesMapping method:RKRequestMethodGET pathPattern:@"/3/tv/popular" keyPath:@"results" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptorPopularSeries];
    
}

- (void) loadMoviesAndSeries {
    
    
    const NSString *API_KEY = @"eeeda4aeb01446fa9cabef99fab242af";
    
    //__block movies = [[NSArray alloc]init];
    
    NSDictionary *queryParams = @{@"api_key" : API_KEY};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/3/movie/top_rated" parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.topRatedMovies = mappingResult.array;
                                                  NSLog(@"TOP RATED MOVIES: %lu", [self.topRatedMovies count]);
//                                                  [movies insertObject:self.topRatedMovies atIndex:0];
                                                  [movies setObject:self.topRatedMovies forKey:@"Most popular movies"];
                                                  [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Could not load movies from API!': %@", error);
                                              }];
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/3/movie/popular" parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.popularMovies = mappingResult.array;
                                                  NSLog(@"TOP RATED MOVIES: %lu", [self.popularMovies count]);
                                                  [movies setObject:self.popularMovies forKey:@"Top rated movies"];

//                                                  [movies insertObject:self.popularMovies atIndex:1];
                                                  [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Could not load movies from API!': %@", error);
                                              }];
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/3/movie/upcoming" parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.upcomingMovies = mappingResult.array;
                                                  NSLog(@"TOP RATED MOVIES: %lu", [self.upcomingMovies count]);
                                                  [movies setObject:self.upcomingMovies forKey:@"Upcoming movies"];

//                                                  [movies insertObject:self.upcomingMovies atIndex:2];
                                                  [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Could not load movies from API!': %@", error);
                                              }];

    [[RKObjectManager sharedManager] getObjectsAtPath:@"/3/tv/top_rated" parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.topRatedSeries = mappingResult.array;
                                                  [movies setObject:self.topRatedSeries forKey:@"Top rated TV shows"];

                                                  [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Could not load movies from API!': %@", error);
                                              }];
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/3/tv/popular" parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.popularSeries = mappingResult.array;
                                                
                                                  [movies setObject:self.popularSeries forKey:@"Most popular TV shows"];

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

-(void) addSegueForTableCell:(MOVMovie *)movie {
    self.selectedMovie = movie;
    
    [self performSegueWithIdentifier:@"movieDetailsSegue" sender:self];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TableCell";
    MOVHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.categoryTitle.text = [categories objectAtIndex:indexPath.row];
    cell.delegate = self;

    cell.movies = [movies objectForKey:[categories objectAtIndex:indexPath.row]];
    
    [cell.movieCollectionView reloadData];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSLog(@"==================================Movie");
    if ([segue.identifier isEqualToString:@"movieDetailsSegue"]) {
        MOVMovieDetailsViewController *movieDetail = [segue destinationViewController];
        movieDetail.movie = self.selectedMovie;
//         [self addSegueForTableCell:self.selectedMovie];
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