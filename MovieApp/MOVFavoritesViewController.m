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

@interface MOVFavoritesViewController ()

{
    NSMutableArray *favorites;
    RLMResults *favoritesMovies;
    RLMResults *favoritesTVShows;
}

@end

@implementation MOVFavoritesViewController

static NSString * const URL_BASE_IMG = @"http://image.tmdb.org/t/p/";
static NSString * const IMAGE_SIZE_W92 = @"w92";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
//    favorites = [[NSMutableArray alloc] init];
//    [favorites addObjectsFromArray:favoritesMovies];
//    [favorites addObjectsFromArray:favoritesTVShows];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [favoritesMovies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *favoritesCellIdentifier = @"FavoritesTableCell";
    MOVFavoritesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:favoritesCellIdentifier forIndexPath:indexPath];
    
    MOVMovieRLM *favMovie = [favoritesMovies objectAtIndex:indexPath.row];
    
    // Movie image
    NSURL * urlImage = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, IMAGE_SIZE_W92, favMovie.poster_path]];
    [cell.favoritesImage sd_setImageWithURL:urlImage];
    
    return cell;
}

-(void)viewDidAppear:(BOOL)animated {
    
    favoritesMovies = [MOVMovieRLM allObjects];
    
    favoritesTVShows = [MOVTVShowRLM allObjects];

    [self.favoritesTable reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
