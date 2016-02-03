//
//  MOVTVShow.m
//  MovieApp
//
//  Created by Adis Cehajic on 24/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import "MOVTVShow.h"
#import "MOVGenre.h"    
#import "MOVGenreRLM.h"
#import "MOVDuration.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation MOVTVShow

-(NSAttributedString *)setTVShowTitleAndYear:(MOVTVShow *)tvShow {
    
    // Release date
    NSString *dateString = tvShow.firstAirDate;
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormater dateFromString:dateString];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    // Setting the name of the tv show and the year of the tv show with different fonts.
    UIFont *helveticaFontTitle = [UIFont fontWithName:@"helvetica neue" size:17.0];
    UIFont *helveticaFontYear = [UIFont fontWithName:@"helvetica neue" size:13.0];
    
    NSDictionary *helveticaDictTitle = [NSDictionary dictionaryWithObject: helveticaFontTitle forKey:NSFontAttributeName];
    NSMutableAttributedString *tvShowTitleString = [[NSMutableAttributedString alloc] initWithString:tvShow.name attributes: helveticaDictTitle];
    
    NSDictionary *helveticaDictYear = [NSDictionary dictionaryWithObject:helveticaFontYear forKey:NSFontAttributeName];
    NSMutableAttributedString *tvShowYearString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" (%lu)", [components year]] attributes:helveticaDictYear];
    
    [tvShowTitleString appendAttributedString:tvShowYearString];
    
    return tvShowTitleString;

}

-(void)convertTVShowGenres:(RLMArray *)tvShowGenresRLM {
    
    self.genres = [[NSMutableArray alloc] initWithCapacity:[tvShowGenresRLM count]];
    MOVGenre *genre = [[MOVGenre alloc] init];
    MOVGenreRLM *genreRLM = [[MOVGenreRLM alloc] init];
    
    for (int i = 0; i < [tvShowGenresRLM count]; i++) {
        genreRLM = [tvShowGenresRLM objectAtIndex:i];
        
        [genre convertMOVGenreRLMToMOVGenre:genreRLM];
        
        [self.genres addObject:genre];
    }
    
}

@end
