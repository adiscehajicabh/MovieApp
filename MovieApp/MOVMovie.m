//
//  MOVMovie.m
//  MovieApp
//
//  Created by Adis Cehajic on 21/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import "MOVMovie.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MOVMovie

-(NSMutableAttributedString *)setMovieTitleAndYear:(MOVMovie *)movie {
    
    // Release date
    NSString *dateString = movie.release_date;
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormater dateFromString:dateString];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    // Setting the name of the movie and the year of the movie with different fonts.
    UIFont *helveticaFontTitle = [UIFont fontWithName:@"helvetica neue" size:17.0];
    UIFont *helveticaFontYear = [UIFont fontWithName:@"helvetica neue" size:13.0];
    
    NSDictionary *helveticaDictTitle = [NSDictionary dictionaryWithObject: helveticaFontTitle forKey:NSFontAttributeName];
    NSMutableAttributedString *movieTitleString = [[NSMutableAttributedString alloc] initWithString:movie.title attributes: helveticaDictTitle];
    
    NSDictionary *helveticaDictYear = [NSDictionary dictionaryWithObject:helveticaFontYear forKey:NSFontAttributeName];
    NSMutableAttributedString *movieYearString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" (%lu)", [components year]] attributes:helveticaDictYear];
    
    [movieTitleString appendAttributedString:movieYearString];
    
    return movieTitleString;
}

//-(NSURL *)posterUrl
//{
////    return [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, POSTER_SIZE_W92, self.poster_path]];
//}
@end
