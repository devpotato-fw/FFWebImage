//
//  UIImageView+WebCache.m
//  WechatMoments
//
//  Created by wangfang on 2017/3/9.
//  Copyright © 2017年 onefboy. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "FFWebImageManager.h"

/**
 *  Cache url
 */
#define CachedImageFile(url) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[url lastPathComponent]]

@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSString *)url placeholderImage:(NSString *)placeholder {

    // 先从images缓存中取出图片url对应的UIImage
    UIImage *image = [WMWebImageManager shareInstance].images[url];
    if (image) {
        // 存在：说明图片已经下载成功，并缓存成功）
        __weak typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!weakSelf) {
                return;
            }
            
            weakSelf.image = image;
            [weakSelf setNeedsLayout];
        });
    } else {
        // 不存在：说明图片并未下载成功过，或者成功下载但是在images里缓存失败，需要在沙盒里寻找对于的图片
        // 获得url对于的沙盒缓存路径
        NSString *file = CachedImageFile(url);
        // 先从沙盒中取出图片
        NSData *data = [NSData dataWithContentsOfFile:file];
        
        if (data) {
            
            __weak typeof(self)weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!weakSelf) {
                    return;
                }
                
                weakSelf.image = [UIImage imageWithData:data];
                [weakSelf setNeedsLayout];
            });
        } else {
            
            __weak typeof(self)weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!weakSelf) {
                    return;
                }
                // 反之沙盒中不存在这个文件
                // 在下载之前显示占位图片
                weakSelf.image = [UIImage imageNamed:placeholder];
                [weakSelf setNeedsLayout];
            });
            
            [self download:url];
        }
    }
}

- (void)download:(NSString *)imageUrl {
    
    // 取出当前图片url对应的下载操作（operation对象）
    NSInvocationOperation *operation = [WMWebImageManager shareInstance].operations[imageUrl];
    if (operation) {
        return;
    }
    
    if (imageUrl) {
        // 创建操作，下载图片
        operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                         selector:@selector(downloadImage:)
                                                           object:imageUrl];
        
        // 添加下载操作到队列中
        [[WMWebImageManager shareInstance].queue addOperation:operation];
        // 将当前下载操作添加到下载操作缓存中 (为了解决重复下载)
        [[WMWebImageManager shareInstance].operations setObject:operation forKey:imageUrl];
    }
}

- (void)downloadImage:(NSString *)url {
    
    NSURL *nsUrl = [NSURL URLWithString:url];
    NSData *data = [[NSData alloc] initWithContentsOfURL:nsUrl];
    UIImage *image = [[UIImage alloc] initWithData:data];
    
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!weakSelf) {
            return;
        }
        
        if (image && url) {
            // 如果存在图片（下载完成），存放图片到图片缓存字典中
            [[WMWebImageManager shareInstance].images setObject:image forKey:url];
            
            //将图片存入沙盒中
            //1. 先将图片转化为NSData
            NSData *data = UIImagePNGRepresentation(image);
            //2.  再生成缓存路径
            [data writeToFile:CachedImageFile(url) atomically:YES];
            // 从字典中移除下载操作 (保证下载失败后，能重新下载)
            // 无论下载成功或是失败，在图片下载的回调里都要将当前的下载操作从下载操作队列中移走：用来保证如果下载失败了，就可以重新开启对应的下载操作进行下载
            [[WMWebImageManager shareInstance].operations removeObjectForKey:url];
            
            weakSelf.image = image;
            [weakSelf setNeedsLayout];
        }
    });
}

@end
