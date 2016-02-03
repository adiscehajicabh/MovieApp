//
//  MOVGenre.h
//  MovieApp
//
//  Created by Adis Cehajic on 29/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOVGenreRLM.h"

@class MOVGenreRLM;

@interface MOVGenre : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;

-(void)convertMOVGenreRLMToMOVGenre:(MOVGenreRLM *)movieGenreRLM;

@end
