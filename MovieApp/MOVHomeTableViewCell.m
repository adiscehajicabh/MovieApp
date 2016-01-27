//
//  MOVHomeTableViewCell.m
//  MovieApp
//
//  Created by Adis Cehajic on 20/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import "MOVHomeTableViewCell.h"
#import "MOVCollectionViewCell.h"
#import "MOVMovie.h"
#import "MOVTVShow.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"
#import "MOVMovieDetailsViewController.h"

@implementation MOVHomeTableViewCell

static NSString * const reuseIdentifier = @"CollectionCell";
static NSString * const URL_BASE_IMG = @"http://image.tmdb.org/t/p/";
static NSString * const POSTER_SIZE_W92 = @"w92";

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MOVCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return [self loadMoviesInCategories:self.movies cellAtIndex:cell cellIndex:indexPath];

}

- (MOVCollectionViewCell *)loadMoviesInCategories:(NSArray *)movies cellAtIndex:(MOVCollectionViewCell *)cell cellIndex:(NSIndexPath *)indexPath {
    
    // Configure the cell
    // Finding movie for each cell and setting the title, year and the poster of the movie
    if ([[movies objectAtIndex:indexPath.row] isKindOfClass:[MOVMovie class]]) {
        
    // Title
    MOVMovie *movie = [movies objectAtIndex:indexPath.row];
    cell.movieTitleCell.text = movie.title;
    
    // Movie poster
    NSURL * url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, POSTER_SIZE_W92, movie.poster_path]];
    [cell.movieImageCell sd_setImageWithURL:url];
    
    // Release date
    NSString *dateString = movie.release_date;
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormater dateFromString:dateString];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    cell.movieYearCell.text = [NSString stringWithFormat:@"%lu", [components year]];
    } else {
        // Title
        MOVTVShow *serie = [movies objectAtIndex:indexPath.row];
        cell.movieTitleCell.text = serie.name;
        
        // Movie poster
        NSURL * url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, POSTER_SIZE_W92, serie.poster_path]];
        [cell.movieImageCell sd_setImageWithURL:url];
        
        // Release date
        NSString *dateString = serie.first_air_date;
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormater dateFromString:dateString];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
        cell.movieYearCell.text = [NSString stringWithFormat:@"%lu", [components year]];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if ([[self.movies objectAtIndex:indexPath.row] isKindOfClass:[MOVMovie class]]) {

        MOVMovie *movie = [self.movies objectAtIndex:indexPath.row];
    
        [self.delegate addSegueMovie:movie];
    } else {
        MOVTVShow *serie = [self.movies objectAtIndex:indexPath.row];
        
        [self.delegate addSegueSerie:serie];
    }
}


@end
