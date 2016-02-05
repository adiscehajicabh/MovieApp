//
//  MOVMovieDetailsViewController.h
//  MovieApp
//
//  Created by Adis Cehajic on 24/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOVMovie.h"
#import "MOVTVShow.h"
#import "MOVMovieDetailsViewController.h"
#import "MOVActor.h"
#import "MOVActorMovie.h"



@interface MOVMovieDetailsViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) MOVMovie *movie;
@property (nonatomic, strong) MOVTVShow *serie;
@property (nonatomic, strong) MOVActorMovie *actorMovie;

@property (weak, nonatomic) IBOutlet UIView *navbarTitle;
@property (weak, nonatomic) IBOutlet UIImageView *moviePoster;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
//@property (weak, nonatomic) IBOutlet UILabel *movieYear;
@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet UITextView *movieDescription;
@property (weak, nonatomic) IBOutlet UILabel *movieVoteAverage;
@property (weak, nonatomic) IBOutlet UILabel *movieVoteCount;
@property (weak, nonatomic) IBOutlet UILabel *movieDurationGenre;


@property (nonatomic, strong) NSArray *movieCast;
@property (weak, nonatomic) IBOutlet UICollectionView *movieCastCollectionView;
@property (nonatomic, strong) NSString *actorId;

@property (nonatomic, strong) NSArray *actorArray;
@property (nonatomic, strong) MOVActor *actor;
@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;

@property (nonatomic,retain) UIPopoverController *popoverController;


-(IBAction)addToFavorites;

@end
