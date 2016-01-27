//
//  MOVMovieActorCollectionViewCell.h
//  MovieApp
//
//  Created by Adis Cehajic on 25/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOVMovieActorCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *movieActorImage;
@property (weak, nonatomic) IBOutlet UILabel *movieActorName;
@property (weak, nonatomic) IBOutlet UIImageView *movieGalleryImage;

@end
