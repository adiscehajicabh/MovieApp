//
//  MOVActor.h
//  MovieApp
//
//  Created by Adis Cehajic on 25/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOVActor : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *placeOfBirth;
@property (nonatomic, strong) NSString *profilePath;
@property (nonatomic, strong) NSString *biography;

@end
