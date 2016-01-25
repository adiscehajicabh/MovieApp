//
//  MOVHomeTableViewCell.h
//  MovieApp
//
//  Created by Adis Cehajic on 20/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOVCollectionViewCell.h"
#import "MOVMovieDetailsViewController.h"
#import "MOVMovie.h"

@protocol MOVHomeTableViewCellDelegate <NSObject>

-(void) addSegueForTableCell:(MOVMovie *)movie;

@end

@interface MOVHomeTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;
@property (nonatomic, strong) NSArray *topRatedMovies;
@property (nonatomic, strong) NSArray *popularMovies;
@property (nonatomic, strong) NSArray *upcomingMovies;
@property (nonatomic, strong) NSArray *topRatedSeries;
@property (nonatomic, strong) NSArray *popularSeries;
@property (nonatomic, strong) NSArray *movies;

@property (nonatomic, weak) id <MOVHomeTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UICollectionView *movieCollectionView;

-(MOVCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
