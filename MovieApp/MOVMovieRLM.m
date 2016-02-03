//
//  MOVMovieRLM.m
//  MovieApp
//
//  Created by Adis Cehajic on 2/1/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import "MOVMovieRLM.h"
#import "MOVMovie.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation MOVMovieRLM

+ (NSString *)primaryKey {
    return @"id";
}

-(NSMutableAttributedString *)setMovieTitleAndYear:(MOVMovieRLM *)movie {
    
    // Release date
    NSString *dateString = movie.release_date;
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormater dateFromString:dateString];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    // Setting the name of the movie and the year of the movie with different fonts.
    UIFont *helveticaFontTitle = [UIFont fontWithName:@"helvetica neue" size:15.0];
    UIFont *helveticaFontYear = [UIFont fontWithName:@"helvetica neue" size:12.0];
    
    NSDictionary *helveticaDictTitle = [NSDictionary dictionaryWithObject: helveticaFontTitle forKey:NSFontAttributeName];
    NSMutableAttributedString *movieTitleString = [[NSMutableAttributedString alloc] initWithString:movie.title attributes: helveticaDictTitle];
    
    NSDictionary *helveticaDictYear = [NSDictionary dictionaryWithObject:helveticaFontYear forKey:NSFontAttributeName];
    NSMutableAttributedString *movieYearString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" (%lu)", [components year]] attributes:helveticaDictYear];
    
    [movieTitleString appendAttributedString:movieYearString];
    
    return movieTitleString;
}

-(void)convertMovieGenres:(NSMutableArray *)movieGenres {
    
    MOVGenre *genre = [[MOVGenre alloc] init];
    MOVGenreRLM *genreRLM = [[MOVGenreRLM alloc] init];
    
    for (int i = 0; i < [movieGenres count]; i++) {
        genre = [movieGenres objectAtIndex:i];
        
        [genreRLM convertMOVGenreToMOVGenreRLM:genre];
        
        [self.genres addObject:genreRLM];
    }
    
}

@end
