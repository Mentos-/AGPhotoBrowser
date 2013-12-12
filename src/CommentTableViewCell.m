//
//  CommentTableViewCell.m
//  AlbumStore
//
//  Created by George Rivara on 3/5/13.
//  Copyright (c) 2013 George Rivara. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code        
        [self setBackgroundColor:[UIColor clearColor]];
        /*
        _attributedLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_attributedLabel];
        
        _nameLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_nameLabel];
        
        _commentLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_commentLabel];
        
        _dateLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_dateLabel];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicatorView setHidesWhenStopped:YES];
        [self.contentView addSubview:_activityIndicatorView];
         */
        
        CGRect profileImageViewFrame = CGRectMake(kCommentTableViewCellInset, kCommentTableViewCellInset, kCommentTableViewCellProfileWidth, kCommentTableViewCellProfileWidth);
        _profileImageView = [[UIImageView alloc]initWithFrame:profileImageViewFrame];
        [self.contentView addSubview:_profileImageView];
        
        _nameTextDateTextView = [[UITextView alloc]init];
        _nameTextDateTextView.userInteractionEnabled = NO;
        _nameTextDateTextView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameTextDateTextView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
