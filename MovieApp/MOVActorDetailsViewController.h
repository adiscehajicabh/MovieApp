//
//  MOVActorDetailsViewController.h
//  MovieApp
//
//  Created by Adis Cehajic on 26/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOVActor.h"

@interface MOVActorDetailsViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *actorPoster;
@property (weak, nonatomic) IBOutlet UIImageView *actorImage;
@property (weak, nonatomic) IBOutlet UITextView *actorBiography;
@property (weak, nonatomic) IBOutlet UILabel *actorName;
@property (weak, nonatomic) IBOutlet UILabel *actorBirthPlace;
@property (weak, nonatomic) IBOutlet UICollectionView *actorMovieCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *actorTvShowCollection;


@property (nonatomic, strong) NSArray *actorArray;
@property (nonatomic, strong) NSArray *actorPosterImages;
@property (nonatomic, strong) MOVActor *actor;
@property (nonatomic, strong) NSString *actorId;
@property (nonatomic, strong) NSString *moviePoster;

@property (nonatomic, strong) NSArray *actorMovies;
@property (nonatomic, strong) NSArray *actorTvShows;

@end
