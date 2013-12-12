//
//  AGComment.m
//  AGPhotoBrowser
//


#import "AGComment.h"
#import "NSDate+HumanizedTime.h"

@interface AGComment ()
{
    NSDate * _date;
    NSString * _userId;
}

@end

@implementation AGComment

-(id)initWithName:(NSString *)name text:(NSString *)text
{
    return [self initWithName:name text:text date:[NSDate date]];
}

-(id)initWithName:(NSString *)name text:(NSString *)text date:(NSDate *)date
{
    return [self initWithName:name text:text date:date andUserId:nil];
}

-(id)initWithName:(NSString *)name text:(NSString *)text date:(NSDate *)date andUserId:(NSString *)userId
{
    self = [super init];
    
    if(self)
    {
        _name = name;
        _text = text;
        _date = date;
        _userId = userId;
    }
    
    return self;
}

-(NSString *)timeSince
{
    NSString * timeSincePost = [_date stringWithHumanizedTimeDifference:NSDateHumanizedSuffixAgo
                                                             withFullString:YES];
    //make Full String or Short String for 0 seconds ago read "Just now"
    if([timeSincePost isEqualToString:@"0 seconds ago"] || [timeSincePost isEqualToString:@"0s ago"])
    {
        return @"Just now";
    }
    return timeSincePost;
}


@end
