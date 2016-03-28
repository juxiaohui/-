//
//  NSString+URLEncoding.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/11.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding{

    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(encoding)));
}
@end
