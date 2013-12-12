//
//  CommentsViewController.m
//  AGPhotoBrowser
//
//  Created by Hellrider on 7/28/13.
//  Copyright (c) 2013 Andrea Giavatto. All rights reserved.
//

#import "AGCommentsViewController.h"
#import "CommentTableViewCell.h"
#import "AGComment.h"

#import <CoreText/CoreText.h>

#define kDateLabelHeight 18
#define kWidthOfCommentTextView 280

@implementation AGCommentsViewController

-(void)reloadData
{
    [_commentTableView reloadData];
    [self scrollToLastCommentAnimated:NO];
}

- (id)init
{
    self = [super initWithNibName:@"CommentsViewController" bundle:nil];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _comments = [[self delegate]commentsViewController:self commentsForImageAtIndex:section];
    
    return [_comments count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AGComment * comment = [_comments objectAtIndex:indexPath.row];
    NSAttributedString * attString = [self attributedStringWithComment:comment];
    
    return [self heightOfAttributedString:attString forWidth:kWidthOfCommentTextView];
}

-(CGFloat)widthOfCommentTextView
{
    CGFloat frameWidth = CGRectGetWidth(self.view.frame);
    
    if(self.showProfilePictureForUserId){
        return frameWidth - kCommentTableViewCellProfileWidth - kCommentTableViewCellBuffer - (kCommentTableViewCellInset * 2);
    }
    
    return frameWidth - (kCommentTableViewCellInset * 2);
}

-(CGFloat)heightOfAttributedString:(NSAttributedString *)attString forWidth:(CGFloat)width
{
    CGRect rect = [attString boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];

    return CGRectGetHeight(rect)+35; //+35 fixes what appears to be an error on Apple's part
}

-(NSAttributedString *)attributedStringWithComment:(AGComment*)comment
{
    NSString * text = comment.text;
    NSString * name = comment.name;
    NSString * date = comment.timeSince;
    
    NSString * commentString = [NSString stringWithFormat:@"%@\n%@\n%@", name, text, date];
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc]initWithString:commentString];
    
    //make the name of the user bold
    UIColor * nameColor = [UIColor blackColor];
    UIFont * nameFont = [UIFont boldSystemFontOfSize:15.0f];
    NSUInteger nameLength = name.length;
    [attString addAttribute:NSFontAttributeName value:nameFont range:NSMakeRange(0, nameLength)];
    [attString addAttribute:NSForegroundColorAttributeName value:nameColor range:NSMakeRange(0, nameLength)];
    
    //keep the text of comment default
    
    //make the date of their comment gray and smaller
    UIColor * dateColor = [UIColor grayColor];
    UIFont * dateFont = [UIFont boldSystemFontOfSize:10.0f];
    NSUInteger dateLength = date.length;
    int loc = (commentString.length - 1) - (dateLength - 1);
    [attString addAttribute:NSFontAttributeName value:dateFont range:NSMakeRange(loc, dateLength)];
    [attString addAttribute:NSForegroundColorAttributeName value:dateColor range:NSMakeRange(loc, dateLength)];
    
    return attString;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block CommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell"];
    if(!cell){
        cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"CommentTableViewCell"];
    }

    AGComment * comment = [_comments objectAtIndex:indexPath.row];
    
    //setup name/text/date textView
    NSAttributedString * attrString = [self attributedStringWithComment:comment];
    CGFloat textViewHeight = [self heightOfAttributedString:attrString forWidth:kWidthOfCommentTextView];
    CGFloat textViewWidth = [self widthOfCommentTextView];
    CGFloat xInset = self.showProfilePictureForUserId ? (kCommentTableViewCellInset + kCommentTableViewCellProfileWidth + kCommentTableViewCellBuffer) : kCommentTableViewCellInset;
    CGRect textViewFrame = CGRectMake(xInset, 0, textViewWidth, textViewHeight);
    
    [cell.nameTextDateTextView setAttributedText:attrString];
    [cell.nameTextDateTextView setFrame:textViewFrame];
    
    cell.profileImageView.hidden = !self.showProfilePictureForUserId;
    
    //setup profileImageView
    if(self.showProfilePictureForUserId)
    {
        CGFloat xInset = kCommentTableViewCellInset;
        CGFloat yInset = kCommentTableViewCellInset;// ( textViewHeight / 2 ) - (kCommentTableViewCellProfileWidth / 2);
        CGFloat height = kCommentTableViewCellProfileWidth;
        CGFloat width = kCommentTableViewCellProfileWidth;
        
        CGRect profileImageViewFrame = CGRectMake(xInset, yInset, width, height);
        cell.profileImageView.frame = profileImageViewFrame;
        [self.delegate commentsViewController:self
                        profileImageForUserId:comment.userId
                          withCompletionBlock:^(UIImage * image)
         {
             if(image){
                 cell.profileImageView.image = image;
             }
         }];
    }
    
    return cell;
}

-(void)closeCommentViewController
{
    //closing is a semaphore to prevent 'scrollToLastCommentAnimated' from being called after we are dismissed
    closing = YES;
    [self.delegate commentsViewControllerDidCancel:self];
    closing = NO;
}

-(void)backgroundButtonClicked
{
    NSLog(@"backgroundButtonClicked");
    [self closeCommentViewController];
}

-(void)keyboardWillShow:(NSNotification*)notification
{
    keyboardIsShowing = YES;
    
    keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    NSLog(@"keyboard frame raw %@", NSStringFromCGRect(keyboardFrame));
    
    [self adjustForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    [self scrollToLastCommentAnimated:YES];
    /*
    // Animate the current view out of the way
    [UIView animateWithDuration:0.3f animations:^
    {
        CGRect commentViewFrame = _commentView.frame;
        commentViewFrame.size.height -= 132;
        _commentView.frame = commentViewFrame;
        
        CGRect commentTableViewFrame = _commentTableView.frame;
        commentTableViewFrame.size.height -= 132;
        _commentTableView.frame = commentTableViewFrame;
    } completion:^(BOOL finished)
    {
        int numberOfRows = [_commentTableView numberOfRowsInSection:0];
        
        if(numberOfRows > 0){
            numberOfRows--;
            
            NSIndexPath *bottomIndexPath = [NSIndexPath indexPathForRow:numberOfRows
                                                              inSection:0];
            
            
            [_commentTableView scrollToRowAtIndexPath:bottomIndexPath
                                     atScrollPosition:UITableViewScrollPositionBottom
                                             animated:YES];
        }
    }];
     */
}
-(void)keyboardWillHide {
    keyboardIsShowing = NO;
    keyboardFrame = CGRectNull;
    [self adjustForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    [self scrollToLastCommentAnimated:YES];
    /*
    // Animate the current view back to its original position
    [UIView animateWithDuration:0.3f animations:^ {
        CGRect commentViewFrame = _commentView.frame;
        commentViewFrame.size.height += 132;
        _commentView.frame = commentViewFrame;
        
        CGRect commentTableViewFrame = _commentTableView.frame;
        commentTableViewFrame.size.height += 132;
        _commentTableView.frame = commentTableViewFrame;
        _commentTableView.contentOffset = CGPointMake(0, _commentTableView.contentOffset.y - 132);
    }completion:^(BOOL finished)
     {
         int numberOfRows = [_commentTableView numberOfRowsInSection:0];
         
         if(numberOfRows > 0){
             numberOfRows--;
             
             NSIndexPath *bottomIndexPath = [NSIndexPath indexPathForRow:numberOfRows
                                                               inSection:0];
             
             
             [_commentTableView scrollToRowAtIndexPath:bottomIndexPath
                                      atScrollPosition:UITableViewScrollPositionBottom
                                              animated:YES];
         }
     }];
     */
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIImage * postButtonImage;
    
    if(![textField.text isEqualToString:@""]){
        [_writeCommentLabel setHidden:YES];
        postButtonImage = [UIImage imageNamed:@"send.png"];
        
    }else{
        postButtonImage = [UIImage imageNamed:@"send-grey.png"];
    }
    [_postCommentButton setImage:postButtonImage forState:UIControlStateNormal];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _commentTextField && [textField.text isEqualToString:@""]){
        [_writeCommentLabel setHidden:NO];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)commentTextFieldChanged
{
    UIImage * postButtonImage;
    
    if([_commentTextField.text isEqualToString:@""]){
        [_writeCommentLabel setHidden:NO];
        postButtonImage = [UIImage imageNamed:@"send-grey.png"];
    }else{
        [_writeCommentLabel setHidden:YES];
        postButtonImage = [UIImage imageNamed:@"send.png"];
    }
    
    [_postCommentButton setImage:postButtonImage forState:UIControlStateNormal];
}

-(void)postCommentButtonClicked
{
    NSString * commentText = _commentTextField.text;
    if(![commentText isEqualToString:@""])
    {
        [self.delegate commentsViewController:self didMakeComment:commentText];
        
        [_commentTextField setText:@""];
        [_commentTextField resignFirstResponder];
    }
}
-(void)closeButtonClicked
{
    [self closeCommentViewController];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"CommentsViewController willAppear");

    [self adjustForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}
-(void)scrollToLastCommentAnimated:(BOOL)animated
{
    int numberOfRows = [_commentTableView numberOfRowsInSection:0];
    
    if(numberOfRows > 0 && !closing)//bug where if we are in the middle of dismissing this will crash us
    {
        NSIndexPath *bottomIndexPath = [NSIndexPath indexPathForRow:numberOfRows-1
                                                          inSection:0];
    

        [_commentTableView scrollToRowAtIndexPath:bottomIndexPath
                                 atScrollPosition:UITableViewScrollPositionBottom
                                         animated:NO];//animated crashes sometimes when view is quickly opened/closed
    }
}

-(void)adjustForOrientation:(UIInterfaceOrientation) orientation
{
    UIInterfaceOrientation currentOrientation = orientation;//[UIApplication sharedApplication].statusBarOrientation;
    BOOL portrait = (currentOrientation == UIInterfaceOrientationPortrait);

    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    
    CGRect statusBarFrame = [self.view.window convertRect:[UIApplication sharedApplication].statusBarFrame toView:self.view];
    float statusBarHeight = statusBarFrame.size.height;//[UIApplication sharedApplication].statusBarFrame.size.height;
    NSLog(@"statusBarHeight: %f", statusBarHeight);
    float statusBarWidth = statusBarFrame.size.width;//[UIApplication sharedApplication].statusBarFrame.size.width;
    NSLog(@"statusBarWidth: %f", statusBarWidth);
    float keyboardHeight = portrait ? keyboardFrame.size.height : keyboardFrame.size.width;
    
    float tabBarAndCaptionHeight = 25;// portrait ? 70 : 60;
    float triangleHeight = 10 + 1; //height of the triangle tail that points at "3 comments"

    CGRect commentViewFrame = _commentView.frame;
    commentViewFrame.origin.x = 0;

    commentViewFrame.origin.y = statusBarHeight;//portrait ? statusBarHeight : statusBarWidth;

    commentViewFrame.size.width = width;

    commentViewFrame.size.height = keyboardIsShowing ? (height - statusBarHeight - keyboardHeight + triangleHeight) : height - tabBarAndCaptionHeight - statusBarHeight;

    _commentView.frame = commentViewFrame;

    [self scrollToLastCommentAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_commentTextField setDelegate:self];
    [_commentTextField addTarget:self
                          action:@selector(commentTextFieldChanged)
                forControlEvents:UIControlEventEditingChanged];
    
    [_postCommentButton addTarget:self
                           action:@selector(postCommentButtonClicked)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [_backgroundButton addTarget:self
                          action:@selector(backgroundButtonClicked)
                forControlEvents:UIControlEventTouchUpInside];
    
    [_closeButton addTarget:self
                     action:@selector(closeButtonClicked)
           forControlEvents:UIControlEventTouchUpInside];
    
    //create rounded corners
    CALayer * layer = [_commentView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:5.0f];
    
    CALayer * backgroundLayer = [_commentBackgroundView layer];
    [backgroundLayer setMasksToBounds:YES];
    [backgroundLayer setCornerRadius:5.0f];
}

//we implement this to enable our gestureRecognizer to pass through to our commentTableView..
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //without it the gesture will block touches from getting to the tableView
    return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self adjustForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBackgroundButton:nil];
    [self setCommentTableView:nil];
    [self setCommentTextField:nil];
    [self setPostCommentButton:nil];
    [self setCommentView:nil];
    [self setCloseButton:nil];
    [self setWriteCommentLabel:nil];
    [self setCommentBackgroundView:nil];
    [super viewDidUnload];
}
@end
