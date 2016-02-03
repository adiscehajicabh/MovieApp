//
//  MOVGenreRLM.h
//  MovieApp
//
//  Created by Adis Cehajic on 2/2/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <Realm/Realm.h>
#import "MOVGenre.h"

@class MOVGenre;

@interface MOVGenreRLM : RLMObject

@property NSString *id;
@property NSString *name;

-(void)convertMOVGenreToMOVGenreRLM:(MOVGenre *)movieGenre;

@end

RLM_ARRAY_TYPE(MOVGenreRLM)
