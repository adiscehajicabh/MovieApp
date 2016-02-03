//
//  MOVActorMovie.h
//  MovieApp
//
//  Created by Adis Cehajic on 27/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOVActorMovie : NSObject

@property (nonatomic, strong) NSString *character;
@property (nonatomic, strong) NSString *creditId;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *originalTitle;
@property (nonatomic, strong) NSString *posterPath;
@property (nonatomic, strong) NSString *releaseDate;

@end
