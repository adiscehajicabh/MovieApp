//
//  MOVGenreRLM.m
//  MovieApp
//
//  Created by Adis Cehajic on 2/2/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import "MOVGenreRLM.h"
#import "MOVGenre.h"

@implementation MOVGenreRLM

-(void)convertMOVGenreToMOVGenreRLM:(MOVGenre *)movieGenre {
        self.id = movieGenre.id;
        self.name = movieGenre.name;
}

@end
