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
#import <RestKit/RestKit.h>
#import "MOVCollectionViewCell.h"



@interface MOVHomeTableViewController ()

{
    NSMutableArray *categories;
}

@property (nonatomic, strong) NSArray *movies;

@end

@implementation MOVHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    categories = [[NSMutableArray alloc] initWithObjects:@"Most popular movies", @"Top rated movies", @"Upcoming movies", @"Top rated TV shows", @"Most popular TV shows", nil];
    
    //Add lines for RestKit
    [self configureRestKit];
    [self loadMovies];
}

- (void)configureRestKit {
    
    // Initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // Initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // Setup object mappings
    RKObjectMapping *movieMapping = [RKObjectMapping mappingForClass:[MOVMovie class]];
    [movieMapping addAttributeMappingsFromArray:@[@"title", @"overview", @"poster_path", @"release_date"]];
    //[movieMapping addAttributeMappingsFromArray:@[@"overview"]];
                                        
    // Register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping method:RKRequestMethodGET pathPattern:@"/3/movie/top_rated" keyPath:@"results" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
}

- (void) loadMovies {
    const NSString *API_KEY = @"eeeda4aeb01446fa9cabef99fab242af";
//    const NSString *QUERY_POPULARITY_DESC = @"popularity.desc";
    
    NSDictionary *queryParams = @{@"api_key" : API_KEY};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/3/movie/top_rated" parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.movies = mappingResult.array;
                                                  MOVMovie *movie = [self.movies objectAtIndex:1];
                                                  NSLog(@"Top movies: %lu", [self.movies count]);

                                                  NSLog(@"Movie title: %@\n Image: %@", [movie title], [movie poster_path]);
                                                  [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
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
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TableCell";
    MOVHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    cell.categoryTitle.text = [categories objectAtIndex:indexPath.row];
    cell.movies = self.movies;
    
    [cell.movieCollectionView reloadData];
//    [cell.movieCollectionView scrollRectToVisible:CGRectZero animated:NO];
    
    return cell;
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
