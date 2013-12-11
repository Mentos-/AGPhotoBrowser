//
//  Comment.h
//  AlbumStore
//
//  Created by George Rivara on 3/5/13.
//  Copyright (c) 2013 George Rivara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic, readonly) NSString * name;
@property (nonatomic, readonly) NSString * text;
@property (nonatomic, readonly) NSString * timeSince;
@property (nonatomic, readonly) NSString * userId;

-(id)initWithName:(NSString *)name text:(NSString *)text date:(NSDate *)date andUserId:(NSString *)userId;

@end
