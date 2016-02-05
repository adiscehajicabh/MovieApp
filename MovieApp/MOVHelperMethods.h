//
//  MOVHelperMethods.h
//  MovieApp
//
//  Created by Adis Cehajic on 2/2/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"

@interface MOVHelperMethods : NSObject

+(NSString *)convertMinutesIntoHours:(NSString *)amount;
+(void)changeFavoriteButtonState:(NSString *)imageName favoriteButton:(UIButton *)button;

@end
