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
@property (nonatomic, strong) NSString *credit_id;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *original_title;
@property (nonatomic, strong) NSString *poster_path;
@property (nonatomic, strong) NSString *release_date;

@end
