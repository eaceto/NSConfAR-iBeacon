//
//  EATwitterAccountTableViewCell.h
//  NSBeacons
//
//  Created by Kimi on 18/03/2014.
//  Copyright (c) 2014 Ezequiel Aceto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EATwitterAccountTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel* displayNameLabel;
@property (nonatomic, strong) IBOutlet UILabel* userNameLabel;
@property (nonatomic, strong) IBOutlet UIImageView* profileImageView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* profileImageLoadingView;

-(void)setProfileImage:(UIImage *)aProfileImage;

@end
