//
//  EATwitterAccountTableViewCell.m
//  NSBeacons
//
//  Created by Kimi on 18/03/2014.
//  Copyright (c) 2014 Ezequiel Aceto. All rights reserved.
//

#import "EATwitterAccountTableViewCell.h"

@implementation EATwitterAccountTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setProfileImage:(UIImage *)aProfileImage
{
    if (aProfileImage == nil) {
        [_profileImageLoadingView setHidden:NO];
        [_profileImageView setHidden:YES];
    }
    else {
        [_profileImageLoadingView setHidden:YES];
        [_profileImageView setImage:aProfileImage];
        [_profileImageView setHidden:NO];
    }
}

@end
