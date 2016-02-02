//
//  MOVVideoRLM.h
//  MovieApp
//
//  Created by Adis Cehajic on 2/2/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <Realm/Realm.h>

@interface MOVVideoRLM : RLMObject

@property NSString *id;
@property NSString *key;
@property NSString *name;
@property NSString *site;
@property NSString *size;
@property NSString *type;

@end
