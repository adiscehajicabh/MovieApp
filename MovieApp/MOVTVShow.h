//
//  MOVTVShow.h
//  MovieApp
//
//  Created by Adis Cehajic on 24/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOVTVShow : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSString *poster_path;
@property (nonatomic, strong) NSString *first_air_date;

@end