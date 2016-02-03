//
//  MOVFavoritesViewController.h
//  MovieApp
//
//  Created by Adis Cehajic on 2/1/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOVMovie.h"
#import "MOVTVShow.h"

@interface MOVFavoritesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *favoritesTable;

@property (nonatomic, strong) MOVMovie *selectedMovie;
@property (nonatomic, strong) MOVTVShow *selectedSerie;

@end
