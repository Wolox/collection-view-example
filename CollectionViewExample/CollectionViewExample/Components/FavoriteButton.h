//
//  FavoriteButton.h
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteButton : UIButton

@property(nonatomic, getter = isOn) BOOL on;

- (void)toggle;

@end
