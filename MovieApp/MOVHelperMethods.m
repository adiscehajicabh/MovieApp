//
//  MOVHelperMethods.m
//  MovieApp
//
//  Created by Adis Cehajic on 2/2/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import "MOVHelperMethods.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"

@implementation MOVHelperMethods

+(NSString *)convertMinutesIntoHours:(NSString *)amount {
    
    int minutesAmount = [amount intValue];
    
    NSInteger hours = minutesAmount / 60;
    NSInteger minutes = minutesAmount % 60;
    
    if (hours > 0) {
        return [NSString stringWithFormat:@"%ldh %ldm", hours, minutes];
    }
    
    return [NSString stringWithFormat:@"%ldm", minutes];
}

/*
 * Sets the image of the favorite button to the inputed image.
 */
+(void)changeFavoriteButtonState:(NSString *)imageName favoriteButton:(UIButton *)button {
    UIImage *btnImage = [UIImage imageNamed:imageName];
    [button setImage:btnImage forState:UIControlStateNormal];
}


@end
