//
//  MOVGenre.m
//  MovieApp
//
//  Created by Adis Cehajic on 29/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//


#import "MOVGenre.h"
#import "MOVGenreRLM.h"

@implementation MOVGenre

-(void)convertMOVGenreRLMToMOVGenre:(MOVGenreRLM *)movieGenreRLM {
    self.id = movieGenreRLM.id;
    self.name = movieGenreRLM.name;
}

@end
