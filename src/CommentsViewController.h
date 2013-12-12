//
//  CommentsViewController.h
//  AlbumStore
//
//  Created by George Rivara on 3/5/13.
//  Copyright (c) 2013 George Rivara. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentsViewController;

@protocol CommentsViewControllerDelegate <NSObject>

- (NSArray *)commentsViewController:(CommentsViewController *)commentsViewController
            commentsForImageAtIndex:(NSInteger)index;

- (void)commentsViewController:(CommentsViewController *)commentsViewController didMakeComment:(NSString *)text;

- (void)commentsViewControllerDidCancel:(CommentsViewController *)commentsViewController;

@optional

- (void)commentsViewController:(CommentsViewController *)commentsViewController
         profileImageForUserId:(NSString *)userId
           withCompletionBlock:(void(^)(UIImage *))block;
@end

@interface CommentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    NSArray * _comments;
    
    BOOL keyboardIsShowing;
    CGRect keyboardFrame;
    
    BOOL closing;
}

@property (weak, nonatomic) id<CommentsViewControllerDelegate> delegate;

@property (assign, nonatomic) BOOL showProfilePictureForUserId;

@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIView *commentBackgroundView;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UIButton *postCommentButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UILabel *writeCommentLabel;
@property (weak, nonatomic) IBOutlet UIButton *backgroundButton;

-(void)reloadData;


@end
