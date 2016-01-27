//
//  MOVActorDetailsViewController.m
//  MovieApp
//
//  Created by Adis Cehajic on 26/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import "MOVActorDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"
#import <RestKit/RestKit.h>
#import "MOVActor.h"
#import "MOVActorImage.h"

@interface MOVActorDetailsViewController ()

@end

@implementation MOVActorDetailsViewController

static NSString * const URL_BASE_IMG = @"http://image.tmdb.org/t/p/";
static NSString * const POSTER_SIZE_W1280 = @"w1280";
static NSString * const IMAGE_SIZE_W92 = @"w92";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadActorDetails:self.actorId];
    [self loadActorImage:self.actorId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)loadActorDetails:(NSString *)actorId {
    
    // Setup object mappings for movies
    RKObjectMapping *actorMapping = [RKObjectMapping mappingForClass:[MOVActor class]];
    [actorMapping addAttributeMappingsFromDictionary:@{
                                                      @"id": @"id",
                                                      @"name": @"name",
                                                      @"birthday": @"birthday",
                                                      @"place_of_birth" : @"place_of_birth",
                                                      @"profile_path" : @"profile_path",
                                                      @"biography" : @"biography"
                                                      }];
    
    // Register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:actorMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.themoviedb.org/3/person/%@?api_key=eeeda4aeb01446fa9cabef99fab242af", actorId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.actorArray = mappingResult.array;
        self.actor = [self.actorArray objectAtIndex:0];
        NSLog(@"======================ACTOR BIRTHDAY: %@\n===============ACTOR PLACE OF BIRTH: %@", self.actor.birthday, self.actor.place_of_birth);
        NSLog(@"========================ACTOR ID: %@", self.actor.id);
        NSLog(@"MOVIE CAST NUMBER: %lu", [self.actorArray count]);
        [self fillActorViewController];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Could not load actor from API!': %@", error);
    }];
    
    [objectRequestOperation start];
    
}

- (void)loadActorImage:(NSString *)actorId {
    
    // Setup object mappings for movies
    RKObjectMapping *actorMapping = [RKObjectMapping mappingForClass:[MOVActorImage class]];
    [actorMapping addAttributeMappingsFromDictionary:@{
                                                       @"backdrop_path": @"backdrop_path",
                                                       }];
    
    // Register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:actorMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"results.media" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.themoviedb.org/3/person/%@/tagged_images?api_key=eeeda4aeb01446fa9cabef99fab242af", actorId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.actorPosterImages = mappingResult.array;
        [self fillActorPoster];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Could not load actor from API!': %@", error);
    }];
    
    [objectRequestOperation start];
    
}

-(void)fillActorViewController {
    
    self.actorName.text = self.actor.name;
    
    // Actor image
    NSURL * urlImage = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, IMAGE_SIZE_W92, self.actor.profile_path]];
    [self.actorImage sd_setImageWithURL:urlImage];
    
    self.actorBiography.text = self.actor.biography;
    
    if (self.actor.place_of_birth != nil && self.actor.birthday != nil) {
        NSString *birthPlace = self.actor.place_of_birth;
        birthPlace = [birthPlace  stringByReplacingOccurrencesOfString:@", " withString:@" - "];
    
        self.actorBirthPlace.text = [NSString stringWithFormat:@"Born %@ in %@", self.actor.birthday, birthPlace];
    }
    
}

-(void)fillActorPoster {
    
    if ([self.actorPosterImages count] > 0) {
        uint32_t rand = arc4random_uniform((uint32_t)[self.actorPosterImages count]);
        NSLog(@"=====================POSTER IMAGE HIS");
        MOVActorImage *actorPosterImage = [self.actorPosterImages objectAtIndex:rand];
    
        NSURL * urlPoster = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, POSTER_SIZE_W1280, actorPosterImage.backdrop_path]];
        [self.actorPoster sd_setImageWithURL:urlPoster];
    } else {
        NSLog(@"=====================POSTER IMAGE MOVIES: %@", self.moviePoster);

        NSURL * urlPoster = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, POSTER_SIZE_W1280, self.moviePoster]];
        [self.actorPoster sd_setImageWithURL:urlPoster];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
