//
//  AGPhotoBrowserOverlayView.m
//  AGPhotoBrowser
//
//  Created by Hellrider on 7/28/13.
//  Copyright (c) 2013 Andrea Giavatto. All rights reserved.
//

#import "AGPhotoBrowserOverlayView.h"

#import <QuartzCore/QuartzCore.h>

@interface AGPhotoBrowserOverlayView () {
	BOOL _animated;
	CAGradientLayer *_gradientLayer;
}

@property (nonatomic, strong) UIView *sharingView;
@property (nonatomic, assign) BOOL descriptionExpanded;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *descriptionLabel;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UIButton *seeMoreButton;
@property (nonatomic, strong, readwrite) UIButton *actionButton;
@property (nonatomic, strong, readwrite) UIButton *commentButton;

@property (nonatomic, assign, readwrite, getter = isVisible) BOOL visible;

@end


@implementation AGPhotoBrowserOverlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setupView];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	_gradientLayer.frame = self.bounds;
	
	self.titleLabel.frame = CGRectMake(20, 35, CGRectGetWidth(self.frame) - 40, 20);
	self.separatorView.frame = CGRectMake(20, CGRectGetMinY(self.titleLabel.frame) + CGRectGetHeight(self.titleLabel.frame), CGRectGetWidth(self.titleLabel.frame), 1);
    
	if (self.descriptionExpanded) {
		CGSize descriptionSize;
		if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
			descriptionSize = [_description sizeWithFont:self.descriptionLabel.font  constrainedToSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 40, MAXFLOAT)];
		} else {
			NSDictionary *textAttributes = @{NSFontAttributeName : self.descriptionLabel.font};
			CGRect descriptionBoundingRect = [_description boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 40, MAXFLOAT)
																					  options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:textAttributes
																					  context:nil];
			descriptionSize = CGSizeMake(ceil(CGRectGetWidth(descriptionBoundingRect)), ceil(CGRectGetHeight(descriptionBoundingRect)));
		}
		self.descriptionLabel.frame = CGRectMake(20, CGRectGetMinY(self.separatorView.frame) + CGRectGetHeight(self.separatorView.frame) + 10, 280, descriptionSize.height);
	} else {
		self.descriptionLabel.frame = CGRectMake(20, CGRectGetMinY(self.separatorView.frame) + CGRectGetHeight(self.separatorView.frame) + 10, 220, 20);
		self.seeMoreButton.frame = CGRectMake(240, CGRectGetMinY(self.separatorView.frame) + CGRectGetHeight(self.separatorView.frame) + 10, 65, 20);
	}
    
	if ([self.descriptionLabel.text length]) {
		CGSize descriptionSize;
		if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
			descriptionSize = [self.descriptionLabel.text sizeWithFont:self.descriptionLabel.font  constrainedToSize:CGSizeMake(self.descriptionLabel.frame.size.width, MAXFLOAT)];
		} else {
			NSDictionary *textAttributes = @{NSFontAttributeName : self.descriptionLabel.font};
			CGRect descriptionBoundingRect = [self.descriptionLabel.text boundingRectWithSize:CGSizeMake(self.descriptionLabel.frame.size.width, MAXFLOAT)
																				   options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:textAttributes
																				   context:nil];
			descriptionSize = CGSizeMake(ceil(CGRectGetWidth(descriptionBoundingRect)), ceil(CGRectGetHeight(descriptionBoundingRect)));
		}
        if (descriptionSize.height > self.descriptionLabel.frame.size.height) {
            self.seeMoreButton.hidden = NO;
        } else {
            self.seeMoreButton.hidden = YES;
        }
        self.descriptionLabel.hidden = NO;
    } else {
        self.descriptionLabel.hidden = YES;
        self.seeMoreButton.hidden = YES;
    }
	
    if ([_title length]) {
		self.titleLabel.hidden = NO;
		self.separatorView.hidden = NO;
	} else {
		self.titleLabel.hidden = YES;
		self.separatorView.hidden = YES;
	}
	
	self.actionButton.frame = CGRectMake(CGRectGetWidth(self.sharingView.frame) - 55 - 10, CGRectGetHeight(self.sharingView.frame) - 32, 55, 32);
    
    self.commentButton.frame = CGRectMake(20, CGRectGetHeight(self.sharingView.frame) - 32, 160, 32);
}

- (void)setupView
{
	self.alpha = 0;
	self.userInteractionEnabled = YES;
    
	[self.sharingView addSubview:self.titleLabel];
	[self.sharingView addSubview:self.separatorView];
	[self.sharingView addSubview:self.descriptionLabel];
	[self.sharingView addSubview:self.seeMoreButton];
	[self.sharingView addSubview:self.actionButton];
    [self.sharingView addSubview:self.commentButton];
	
	[self addSubview:self.sharingView];
}


#pragma mark - Public methods

- (void)showOverlayAnimated:(BOOL)animated
{
	_animated = animated;
	self.visible = YES;
}

- (void)hideOverlayAnimated:(BOOL)animated
{
	_animated = animated;
	self.visible = NO;
}

- (void)resetOverlayView
{
	if (floor(CGRectGetHeight(self.frame)) != AGPhotoBrowserOverlayInitialHeight) {
		__block CGRect initialSharingFrame = self.frame;
		initialSharingFrame.origin.y = round(CGRectGetHeight([UIScreen mainScreen].bounds) - AGPhotoBrowserOverlayInitialHeight);
		
		[UIView animateWithDuration:0.15
						 animations:^(){
							 self.frame = initialSharingFrame;
						 } completion:^(BOOL finished){
							 initialSharingFrame.size.height = AGPhotoBrowserOverlayInitialHeight;
							 self.descriptionExpanded = NO;
							 [self setNeedsLayout];
							 [UIView animateWithDuration:AGPhotoBrowserAnimationDuration
											  animations:^(){
												  self.frame = initialSharingFrame;
											  }];
						 }];
	}
    
    [self updateCommentButtonTitle];
}


#pragma mark - Buttons

- (void)p_actionButtonTapped:(UIButton *)sender
{
	if ([_delegate respondsToSelector:@selector(sharingView:didTapOnActionButton:)]) {
		[_delegate sharingView:self didTapOnActionButton:sender];
	}
}

- (void)p_commentButtonTapped:(UIButton *)sender
{
	if ([_delegate respondsToSelector:@selector(sharingView:didTapOnCommentButton:)]) {
		[_delegate sharingView:self didTapOnCommentButton:sender];
	}
}

- (void)p_seeMoreButtonTapped:(UIButton *)sender
{
	if ([_delegate respondsToSelector:@selector(sharingView:didTapOnSeeMoreButton:)]) {
		[_delegate sharingView:self didTapOnSeeMoreButton:sender];
		self.descriptionExpanded = YES;
		[self setNeedsLayout];
		[self.sharingView addGestureRecognizer:self.tapGesture];
	}
}


#pragma mark - Recognizers

- (void)p_tapGestureTapped:(UITapGestureRecognizer *)recognizer
{
	[self resetOverlayView];
}


#pragma mark - Setters

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	self.sharingView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
}

- (void)setVisible:(BOOL)visible
{
	_visible = visible;
	
	CGFloat newAlpha = _visible ? 1. : 0.;
	
	NSTimeInterval animationDuration = _animated ? AGPhotoBrowserAnimationDuration : 0;
	
	[UIView animateWithDuration:animationDuration
					 animations:^(){
						 self.alpha = newAlpha;
						 self.actionButton.alpha = newAlpha;
                         self.commentButton.alpha = newAlpha;
					 }];
}

- (void)setTitle:(NSString *)title
{
	_title = title;
	
    if (_title) {
        self.titleLabel.text = _title;
    }
    
    [self setNeedsLayout];
}

- (void)setDescription:(NSString *)description
{
	_description = description;
	
	if ([_description length]) {
		self.descriptionLabel.text = _description;
	} else {
		self.descriptionLabel.text = @"";
	}
    
    [self setNeedsLayout];
}


#pragma mark - Getters

- (UIView *)sharingView
{
	if (!_sharingView) {
		_sharingView = [[UIView alloc] initWithFrame:self.bounds];
		_gradientLayer = [CAGradientLayer layer];
		_gradientLayer.frame = self.bounds;
		_gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
		[_sharingView.layer insertSublayer:_gradientLayer atIndex:0];
	}
	
	return _sharingView;
}

- (UILabel *)titleLabel
{
	if (!_titleLabel) {
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, CGRectGetWidth(self.frame) - 40, 20)];
		_titleLabel.textColor = [UIColor colorWithWhite:0.9 alpha:0.9];
		_titleLabel.font = [UIFont boldSystemFontOfSize:14];
		_titleLabel.backgroundColor = [UIColor clearColor];
	}
	
	return _titleLabel;
}

- (UIView *)separatorView
{
	if (!_separatorView) {
		_separatorView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMinY(self.titleLabel.frame) + CGRectGetHeight(self.titleLabel.frame), 280, 1)];
		_separatorView.backgroundColor = [UIColor lightGrayColor];
        _separatorView.hidden = YES;
	}
	
	return _separatorView;
}

- (UILabel *)descriptionLabel
{
	if (!_descriptionLabel) {
		_descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(self.frame) - 10 - 23, 160, 20)];
		_descriptionLabel.textColor = [UIColor colorWithWhite:0.9 alpha:0.9];
		_descriptionLabel.font = [UIFont systemFontOfSize:13];
		_descriptionLabel.backgroundColor = [UIColor clearColor];
		_descriptionLabel.numberOfLines = 0;
        
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(descriptionLabelClicked:)];
        // if labelView is not set userInteractionEnabled, you must do so
        [_descriptionLabel setUserInteractionEnabled:YES];
        [_descriptionLabel addGestureRecognizer:gesture];
	}
	
	return _descriptionLabel;
}

-(void)descriptionLabelClicked:(UITapGestureRecognizer *)gesture
{
    if([self.delegate respondsToSelector:@selector(sharingView:didTapOnDescriptionLabel:)])
    {
        [self.delegate sharingView:self didTapOnDescriptionLabel:_descriptionLabel];
    }
}

- (UIButton *)seeMoreButton
{
	if (!_seeMoreButton) {
		_seeMoreButton = [[UIButton alloc] initWithFrame:CGRectMake(180, CGRectGetHeight(self.frame) - 10 - 23, 65, 20)];
		[_seeMoreButton setTitle:NSLocalizedString(@"See More", @"Title for See more button") forState:UIControlStateNormal];
		[_seeMoreButton setBackgroundColor:[UIColor clearColor]];
		[_seeMoreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		_seeMoreButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        _seeMoreButton.hidden = YES;
		
		[_seeMoreButton addTarget:self action:@selector(p_seeMoreButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	return _seeMoreButton;
}

- (UIButton *)actionButton
{
	if (!_actionButton) {
		_actionButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 55 - 10, CGRectGetHeight(self.frame) - 32 - 5, 55, 32)];
		[_actionButton setTitle:NSLocalizedString(@"● ● ●", @"Title for Action button") forState:UIControlStateNormal];
		[_actionButton setBackgroundColor:[UIColor clearColor]];
		[_actionButton setTitleColor:[UIColor colorWithWhite:0.9 alpha:0.9] forState:UIControlStateNormal];
		[_actionButton setTitleColor:[UIColor colorWithWhite:0.9 alpha:0.9] forState:UIControlStateHighlighted];
		[_actionButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        
		[_actionButton addTarget:self action:@selector(p_actionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	return _actionButton;
}

- (UIButton *)commentButton
{
	if (!_commentButton) {
		_commentButton = [[UIButton alloc] init];

        _commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		[_commentButton setBackgroundColor:[UIColor clearColor]];
		[_commentButton setTitleColor:[UIColor colorWithWhite:0.9 alpha:0.9] forState:UIControlStateNormal];
		[_commentButton setTitleColor:[UIColor colorWithWhite:0.9 alpha:0.9] forState:UIControlStateHighlighted];
        UIFont * font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];// [UIFont boldSystemFontOfSize:12.0f];
		[_commentButton.titleLabel setFont:font];
        
		[_commentButton addTarget:self action:@selector(p_commentButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	}
    
    [self updateCommentButtonTitle];
	
	return _commentButton;
}

-(void)updateCommentButtonTitle
{
    NSUInteger numberOfComments = [self.delegate sharingViewNumberOfComments:self];
    NSString * title = [NSString stringWithFormat:@"%d comments", numberOfComments];
    [_commentButton setTitle:title forState:UIControlStateNormal];
}

- (UITapGestureRecognizer *)tapGesture
{
	if (!_tapGesture) {
		_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_tapGestureTapped:)];
		_tapGesture.numberOfTouchesRequired = 1;
	}
	
	return _tapGesture;
}

@end
