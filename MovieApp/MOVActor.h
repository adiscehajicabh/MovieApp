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
@property (nonatomic, strong) NSString *place_of_birth;
@property (nonatomic, strong) NSString *profile_path;
@property (nonatomic, strong) NSString *biography;

@end
