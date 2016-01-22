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
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"

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
    
    // Configure the cell
    
    
    MOVMovie *movie = [self.movies objectAtIndex:indexPath.row];
    NSLog(@"Movie count 22222: %@", movie.title);

    cell.movieTitleCell.text = movie.title;
    
    
    
    NSURL * url = [NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, POSTER_SIZE_W92, movie.poster_path];
    [cell.movieImageCell sd_setImageWithURL:url];
    
    NSString *dateString = movie.release_date;
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormater dateFromString:dateString];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];

    cell.movieYearCell.text = [NSString stringWithFormat:@"%lu", [components year]];

    return cell;
}

- (void) reload {
    //[self.movieCollection reloadInputViews];
}

@end
