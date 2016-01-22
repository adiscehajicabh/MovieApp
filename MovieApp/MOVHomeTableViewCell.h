//
//  MOVHomeTableViewCell.h
//  MovieApp
//
//  Created by Adis Cehajic on 20/01/16.
//  Copyright © 2016 Adis Cehajic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOVCollectionViewCell.h"

@interface MOVHomeTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;
@property (nonatomic, strong) NSArray *movies;
@property (strong, nonatomic) IBOutlet UICollectionView *movieCollectionView;


-(void) reload;

@end
