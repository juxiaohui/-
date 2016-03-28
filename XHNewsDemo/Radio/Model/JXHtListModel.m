//
//  JXHtListModel.m
//  XHNewsDemo
//
//  Created by iosdev on 16/3/16.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHtListModel.h"

@implementation JXHtListModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
        return @{
                 
                 @"imgsrc" : @"radio.imgsrc",
                 @"title" :  @"radio.title",
                 };
}
@end
