//
//  FavoriteButton.m
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "FavoriteButton.h"

@interface FavoriteButton ()

@property(readonly, nonatomic) UIImage * onImage;
@property(readonly, nonatomic) UIImage * offImage;

@end

@implementation FavoriteButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureButton];
    }
    return self;
}

- (void)awakeFromNib {
    [self configureButton];
}

- (void)setOn:(BOOL)on {
    if (self.on == on) {
        return;
    }
    _on = on;
    UIImage * image = (on) ? self.onImage : self.offImage;
    [self setImage:image forState:UIControlStateNormal];
}

- (void)toggle {
    self.on = !self.on;
}

#pragma mark - Private Methods

- (void)configureButton {
    _onImage = [UIImage imageNamed:@"fav_on"];
    _offImage = [UIImage imageNamed:@"fav_off"];
    self.on = NO;
}

@end
