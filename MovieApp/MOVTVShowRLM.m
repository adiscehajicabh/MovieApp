//
//  MOVTVShowRLM.m
//  MovieApp
//
//  Created by Adis Cehajic on 2/1/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import "MOVTVShowRLM.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MOVTVShowRLM

-(NSAttributedString *)setTVShowTitleAndYear:(MOVTVShowRLM *)tvShow {
    
    // Release date
    NSString *dateString = tvShow.first_air_date;
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormater dateFromString:dateString];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    // Setting the name of the tv show and the year of the tv show with different fonts.
    UIFont *helveticaFontTitle = [UIFont fontWithName:@"helvetica neue" size:15.0];
    UIFont *helveticaFontYear = [UIFont fontWithName:@"helvetica neue" size:12.0];
    
    NSDictionary *helveticaDictTitle = [NSDictionary dictionaryWithObject: helveticaFontTitle forKey:NSFontAttributeName];
    NSMutableAttributedString *tvShowTitleString = [[NSMutableAttributedString alloc] initWithString:tvShow.name attributes: helveticaDictTitle];
    
    NSDictionary *helveticaDictYear = [NSDictionary dictionaryWithObject:helveticaFontYear forKey:NSFontAttributeName];
    NSMutableAttributedString *tvShowYearString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" (%lu)", [components year]] attributes:helveticaDictYear];
    
    [tvShowTitleString appendAttributedString:tvShowYearString];
    
    return tvShowTitleString;
    
}

@end
