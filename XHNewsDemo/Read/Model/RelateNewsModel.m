//
//  RelateNewsModel.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/18.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "RelateNewsModel.h"

@implementation RelateNewsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.tid = value;
    }
}

-(id)valueForUndefinedKey:(NSString *)key{
    return nil;
}
@end
