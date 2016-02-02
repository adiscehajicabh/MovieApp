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

@interface MOVFavoritesViewController ()

{
    NSMutableArray *favorites;
    RLMResults *favoritesMovies;
    RLMResults *favoritesTVShows;
}

@end

@implementation MOVFavoritesViewController

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
        cell.favoritesDuration.text = favMovie.runtime;
        cell.favoritesRaiting.text = [NSString stringWithFormat:@"%.1f", [favMovie.vote_average floatValue]];
    
    } else {
        
        MOVTVShowRLM *favTVShow = [favorites objectAtIndex:indexPath.row];
        
        // TV show image
        NSURL * urlImage = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, IMAGE_SIZE_W92, favTVShow.poster_path]];
        [cell.favoritesImage sd_setImageWithURL:urlImage];
        
        cell.favoritesTitle.attributedText = [favTVShow setTVShowTitleAndYear:favTVShow];
        cell.favoritesDuration.text = favTVShow.episode_run_time;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
