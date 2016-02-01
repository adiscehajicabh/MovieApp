//
//  MOVFavoritesTableViewCell.h
//  MovieApp
//
//  Created by Adis Cehajic on 2/1/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOVFavoritesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *favoritesImage;
@property (weak, nonatomic) IBOutlet UILabel *favoritesTitle;
@property (weak, nonatomic) IBOutlet UILabel *favoritesDuration;
@property (weak, nonatomic) IBOutlet UILabel *favoritesRaiting;

@end
