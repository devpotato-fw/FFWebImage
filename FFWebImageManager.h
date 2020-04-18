//
//  FFWebImageManager.h
//  WechatMoments
//
//  Created by wangfang on 2017/3/9.
//  Copyright © 2017年 onefboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFWebImageManager : NSObject

+ (FFWebImageManager *)shareInstance;

// save all images
@property (strong, nonatomic) NSMutableDictionary *images;

// save all operations
@property (strong, nonatomic) NSMutableDictionary *operations;

@property (strong, nonatomic) NSOperationQueue *queue;

@end
