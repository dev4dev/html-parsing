//
//  ImageCell.m
//  ParseHTML
//
//  Created by Alex Antonyuk on 11/11/12.
//  Copyright (c) 2012 Alex Antonyuk. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell

- (id)
initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.picView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 200.0)];
		self.picView.contentMode = UIViewContentModeCenter;
		[self.contentView addSubview:self.picView];
    }
	
    return self;
}

@end
