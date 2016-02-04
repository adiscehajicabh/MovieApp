//
//  MOVActorMovieCollectionViewCell.h
//  MovieApp
//
//  Created by Adis Cehajic on 27/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOVMovie.h"


@interface MOVActorMovieCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *actorMovieImage;
@property (weak, nonatomic) IBOutlet UILabel *actorMovieName;

@end
