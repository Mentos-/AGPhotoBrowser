//
//  NSDate+HumanizedTime.h
//  HumanizedTimeDemo
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NSDateHumanizedType)
{
	NSDateHumanizedSuffixNone = 0,
  NSDateHumanizedSuffixLeft,
  NSDateHumanizedSuffixAgo
};

@interface NSDate (HumanizedTime)

- (NSString *) stringWithHumanizedTimeDifference:(NSDateHumanizedType) humanizedType withFullString:(BOOL) fullStrings;

@end
