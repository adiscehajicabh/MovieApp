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
#import "MOVActorMovie.h"
#import "MOVTVShowCast.h"
#import "MOVActorTVShow.h"
#import "MOVActorMovieCollectionViewCell.h"
#import "MOVActorTVShowCollectionViewCell.h"
#import "MOVConstants.h"
#import "MOVMovieDetailsViewController.h"
#import "MOVObjectMapping.h"

@interface MOVActorDetailsViewController ()

@end

@implementation MOVActorDetailsViewController

static NSString * const movieIdentifier = @"ActorMovieCollectionCell";
static NSString * const tvShowIdentifier = @"ActorTVShowCollectionCell";
static NSString * const actorMovieSegue = @"actorMovieDetailSegue";
static NSString * const actorTVShowSegue = @"actorTVShowDetailSegue";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.movies = [[NSMutableArray alloc] init];
    self.tvShows = [[NSMutableArray alloc] init];
    
    [self loadActorDetails:self.actorId];
    [self loadActorImage:self.actorId];
    [self loadActorMovie:self.actorId];
    [self loadActorTVShow:self.actorId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.actorMovieCollection) {
        return ([self.actorMovies count] > 15) ? 15 : [self.actorMovies count];
    } else {
        return ([self.actorTvShows count] > 15) ? 15 : [self.actorTvShows count];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.actorMovieCollection) {
        
        MOVActorMovieCollectionViewCell *cellMovie = [collectionView dequeueReusableCellWithReuseIdentifier:movieIdentifier forIndexPath:indexPath];
    
//        cellMovie.delegate = self;
        
        MOVActorMovie *actorMovie = [self.actorMovies objectAtIndex:indexPath.row];
    
        MOVMovie *loadedMovie = [[MOVMovie alloc] init];
        [MOVObjectMapping loadMovie:actorMovie.id loadedMovie:loadedMovie];
        [self.movies addObject:loadedMovie];
        
        cellMovie.actorMovieName.text = actorMovie.title;
        
        // Actor movie image
        NSURL * urlImageMovie = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, IMAGE_SIZE_W92, actorMovie.posterPath]];
        [cellMovie.actorMovieImage sd_setImageWithURL:urlImageMovie];
    
        cellMovie.actorMovieImage.layer.cornerRadius = 5;
        cellMovie.actorMovieImage.layer.masksToBounds = YES;
        
        return cellMovie;
    } else {
        
        MOVActorTVShowCollectionViewCell *cellTvShows = [collectionView dequeueReusableCellWithReuseIdentifier:tvShowIdentifier forIndexPath:indexPath];
    
        MOVActorTVShow *actorTvShow = [self.actorTvShows objectAtIndex:indexPath.row];
    
        MOVTVShow *loadedTVShow = [[MOVTVShow alloc] init];
        [MOVObjectMapping loadTVShow:actorTvShow.id loadedTVShow:loadedTVShow];
        [self.tvShows addObject:loadedTVShow];
        
        cellTvShows.actorTvShowName.text = actorTvShow.name;
    
        // Actor movie image
        NSURL * urlImageTvShow = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, IMAGE_SIZE_W92, actorTvShow.posterPath]];
        [cellTvShows.actorTvShowImage sd_setImageWithURL:urlImageTvShow];
    
        cellTvShows.actorTvShowImage.layer.cornerRadius = 5;
        cellTvShows.actorTvShowImage.layer.masksToBounds = YES;
        
        return cellTvShows;
    }
}

- (void)loadActorDetails:(NSString *)actorId {
    
    // Setup object mappings for movies
    RKObjectMapping *actorMapping = [RKObjectMapping mappingForClass:[MOVActor class]];
    [actorMapping addAttributeMappingsFromDictionary:@{
                                                      @"id": @"id",
                                                      @"name": @"name",
                                                      @"birthday": @"birthday",
                                                      @"place_of_birth" : @"placeOfBirth",
                                                      @"profile_path" : @"profilePath",
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
                                                       @"backdrop_path": @"backdropPath",
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
    NSURL * urlImage = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, IMAGE_SIZE_W92, self.actor.profilePath]];
    [self.actorImage sd_setImageWithURL:urlImage];
    
    self.actorBiography.text = self.actor.biography;
    
    if (self.actor.placeOfBirth != nil && self.actor.birthday != nil) {
        NSString *birthPlace = self.actor.placeOfBirth;
        birthPlace = [birthPlace  stringByReplacingOccurrencesOfString:@", " withString:@" - "];
    
        self.actorBirthPlace.text = [NSString stringWithFormat:@"Born %@ in %@", self.actor.birthday, birthPlace];
    }
    
    // Setting the navbar title.
    self.title = self.actor.name;
    
}

-(void)fillActorPoster {
    
    if ([self.actorPosterImages count] > 0) {
        uint32_t rand = arc4random_uniform((uint32_t)[self.actorPosterImages count]);
        MOVActorImage *actorPosterImage = [self.actorPosterImages objectAtIndex:rand];
    
        NSURL * urlPoster = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, POSTER_SIZE_W1280, actorPosterImage.backdropPath]];
        [self.actorPoster sd_setImageWithURL:urlPoster];
    } else {
        NSURL * urlPoster = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", URL_BASE_IMG, POSTER_SIZE_W1280, self.moviePoster]];
        [self.actorPoster sd_setImageWithURL:urlPoster];
    }
    
}

- (void)loadActorMovie:(NSString *)actorId{
    
    // Setup object mappings for movies
    RKObjectMapping *castMapping = [RKObjectMapping mappingForClass:[MOVActorMovie class]];
    [castMapping addAttributeMappingsFromDictionary:@{
                                                      @"character": @"character",
                                                      @"credit_id": @"creditId",
                                                      @"id": @"id",
                                                      @"release_date" : @"releaseDate",
                                                      @"title" : @"title",
                                                      @"poster_path" : @"posterPath",
                                                      @"original_title" : @"originalTitle"
                                                       }];
    
    // Register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:castMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"cast" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.themoviedb.org/3/person/%d/movie_credits?api_key=eeeda4aeb01446fa9cabef99fab242af", [actorId intValue]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.actorMovies = mappingResult.array;
        [self.actorMovieCollection reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Could not load actor movies from API!': %@", error);
    }];
    
    [objectRequestOperation start];
    
}

- (void)loadActorTVShow:(NSString *)actorId{
    
    // Setup object mappings for movies
    RKObjectMapping *castMapping = [RKObjectMapping mappingForClass:[MOVActorTVShow class]];
    [castMapping addAttributeMappingsFromDictionary:@{
                                                      @"character": @"character",
                                                      @"credit_id": @"creditId",
                                                      @"episode_count" : @"episodeCount",
                                                      @"first_air_date" : @"firstAirDate",
                                                      @"id": @"id",
                                                      @"name" : @"name",
                                                      @"original_name" : @"originalName",
                                                      @"poster_path" : @"posterPath"
                                                      }];
    
    // Register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:castMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"cast" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.themoviedb.org/3/person/%d/tv_credits?api_key=eeeda4aeb01446fa9cabef99fab242af", [actorId intValue]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.actorTvShows = mappingResult.array;
        [self.actorTVShowCollection reloadData];
        NSLog(@"TV SHOW NUMBER: %lu", [self.actorTvShows count]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Could not load movie cast from API!': %@", error);
    }];
    
    [objectRequestOperation start];
    
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    MOVMovieDetailsViewController *movieDetail = [segue destinationViewController];
    
    if ([segue.identifier isEqualToString:actorMovieSegue]) {
        
        NSIndexPath *indexPath = [self.actorMovieCollection indexPathForCell:sender];
        
        MOVMovie *actorMovie = [self.movies objectAtIndex:indexPath.row];
        
        movieDetail.movie = actorMovie;
        
    } else if ([segue.identifier isEqualToString:actorTVShowSegue]) {
        
        NSIndexPath *indexPath = [self.actorTVShowCollection indexPathForCell:sender];
        
        MOVTVShow *actorTVShow = [self.tvShows objectAtIndex:indexPath.row];
            
        movieDetail.serie = actorTVShow;
        
    }
}


@end
