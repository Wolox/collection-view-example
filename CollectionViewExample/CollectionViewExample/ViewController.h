//
//  ViewController.h
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *showProductButton;
@property (weak, nonatomic) IBOutlet UIView *productCollectionView;
- (IBAction)showProductCollectionButtonPressed:(id)sender;

@end
