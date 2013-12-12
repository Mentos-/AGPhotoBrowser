//
//  AGCommentTableViewCell.h
//  AGPhotoBrowser
//
//  Created by Hellrider on 7/28/13.
//  Copyright (c) 2013 Andrea Giavatto. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCommentTableViewCellBuffer 5 //buffer between imageView and textView
#define kCommentTableViewCellProfileWidth 40

#define kCommentTableViewCellInset 10

@interface AGCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView * profileImageView;
@property (nonatomic, strong) UITextView * nameTextDateTextView;

@end
