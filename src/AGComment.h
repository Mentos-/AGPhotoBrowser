//
//  AGComment.h
//  AGPhotoBrowser
//

#import <Foundation/Foundation.h>

@interface AGComment : NSObject

@property (nonatomic, readonly) NSString * name;
@property (nonatomic, readonly) NSString * text;
@property (nonatomic, readonly) NSString * timeSince;
@property (nonatomic, readonly) NSString * userId;

-(id)initWithName:(NSString *)name text:(NSString *)text;
-(id)initWithName:(NSString *)name text:(NSString *)text date:(NSDate *)date;
-(id)initWithName:(NSString *)name text:(NSString *)text date:(NSDate *)date andUserId:(NSString *)userId;

@end
