//
//  FFWebImageManager.m
//  WechatMoments
//
//  Created by wangfang on 2017/3/9.
//  Copyright © 2017年 onefboy. All rights reserved.
//

#import "FFWebImageManager.h"

@implementation FFWebImageManager

static FFWebImageManager *instance = nil;

+ (FFWebImageManager *)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (NSMutableDictionary *)images {

    if (!_images) {
        _images = [NSMutableDictionary dictionary];
    }
    return _images;
}

- (NSMutableDictionary *)operations {
    
    if (!_operations) {
        _operations = [NSMutableDictionary dictionary];
    }
    return _operations;
}

- (NSOperationQueue *)queue {

    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

@end
