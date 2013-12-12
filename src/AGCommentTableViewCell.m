//
//  AGCommentTableViewCell.m
//  AGPhotoBrowser
//

#import "AGCommentTableViewCell.h"

@implementation AGCommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code        
        [self setBackgroundColor:[UIColor clearColor]];

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

@end
