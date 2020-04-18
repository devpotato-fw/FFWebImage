//
//  UIImageView+WebCache.h
//  WechatMoments
//
//  Created by wangfang on 2017/3/9.
//  Copyright © 2017年 onefboy. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^WMWebImageCompletionBlock)(UIImage *image, NSString *imageURL);

@interface UIImageView (WebCache)

- (void)setImageWithURL:(NSString *)url placeholderImage:(NSString *)placeholder;
//- (void)setImageWithURL:(NSString *)url placeholderImage:(NSString *)placeholder block:(WMWebImageCompletionBlock)block;

@end
