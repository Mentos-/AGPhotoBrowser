//
//  AGPhotoBrowserDataSource.h
//  AGPhotoBrowser
//
//  Created by Hellrider on 7/28/13.
//  Copyright (c) 2013 Andrea Giavatto. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AGPhotoBrowserDataSource <NSObject>

- (NSInteger)numberOfPhotosForPhotoBrowser:(AGPhotoBrowserView *)photoBrowser;
- (UIImage *)photoBrowser:(AGPhotoBrowserView *)photoBrowser imageAtIndex:(NSInteger)index;

@optional

- (NSString *)photoBrowser:(AGPhotoBrowserView *)photoBrowser titleForImageAtIndex:(NSInteger)index;
- (NSString *)photoBrowser:(AGPhotoBrowserView *)photoBrowser descriptionForImageAtIndex:(NSInteger)index;

//Comments
- (NSUInteger)photoBrowser:(AGPhotoBrowserView *)photoBrowser numberOfCommentsForImageAtIndex:(NSInteger)index;
- (NSArray *) photoBrowser:(AGPhotoBrowserView *)photoBrowser commentsForImageAtIndex:(NSInteger)index;
- (void)photoBrowser:(AGPhotoBrowserView *)photoBrowser profileImageForUserId:(NSString *)userId withCompletionBlock:(void(^)(UIImage *))block;

@end
