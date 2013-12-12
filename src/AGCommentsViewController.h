//
//  AGCommentsViewController.h
//  AGPhotoBrowser
//
//  Created by Hellrider on 7/28/13.
//  Copyright (c) 2013 Andrea Giavatto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AGCommentsViewController;

@protocol AGCommentsViewControllerDelegate <NSObject>

- (NSArray *)commentsViewController:(AGCommentsViewController *)commentsViewController
            commentsForImageAtIndex:(NSInteger)index;

- (void)commentsViewController:(AGCommentsViewController *)commentsViewController didMakeComment:(NSString *)text;

- (void)commentsViewControllerDidCancel:(AGCommentsViewController *)commentsViewController;

@optional

- (void)commentsViewController:(AGCommentsViewController *)commentsViewController
         profileImageForUserId:(NSString *)userId
           withCompletionBlock:(void(^)(UIImage *))block;
@end

@interface AGCommentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    NSArray * _comments;
    
    BOOL keyboardIsShowing;
    CGRect keyboardFrame;
    
    BOOL closing;
}

@property (weak, nonatomic) id<AGCommentsViewControllerDelegate> delegate;

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
