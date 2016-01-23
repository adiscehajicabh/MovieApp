//
//  MOVHomeTableViewCell.h
//  MovieApp
//
//  Created by Adis Cehajic on 20/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOVCollectionViewCell.h"

@interface MOVHomeTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;
@property (nonatomic, strong) NSArray *topRatedMovies;
@property (nonatomic, strong) NSArray *popularMovies;
@property (nonatomic, strong) NSArray *upcomingMovies;
@property (nonatomic, strong) NSArray *topRatedSeries;
@property (nonatomic, strong) NSArray *popularSeries;


@property (strong, nonatomic) IBOutlet UICollectionView *movieCollectionView;

-(MOVCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
