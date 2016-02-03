//
//  MOVObjectMapping.h
//  MovieApp
//
//  Created by Adis Cehajic on 2/3/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOVMovie.h"

@interface MOVObjectMapping : NSObject

+(void)addMovieDurationAndGenres:(MOVMovie *)movie;

@end
