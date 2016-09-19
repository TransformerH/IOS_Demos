//
//  Manager.m
//  PickFromPhotos
//
//  Created by 韩雪滢 on 9/18/16.
//  Copyright © 2016 韩雪滢. All rights reserved.
//

#import "Manager.h"
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

void ManagerWriteToPhotoAlbum(UIImage *image,NSString *album,ManagerSaveHandler completionManager){
    [[Manager sharedManager] saveImage:image toAlbum:album completionHandler:completionManager];
}

@interface Manager()

@property (nonatomic,strong)PHPhotoLibrary *photoLibrary;

@end

@implementation Manager

static Manager *_manager;
+ (instancetype)sharedManager{
    static dispatch_once_t dec;
    dispatch_once(&dec, ^{
        _manager = [[Manager alloc] init];
    });
    
    return _manager;
}

- (instancetype)init{
    self = [super init];
    if(self){
    }
    
    return self;
}

- (PHPhotoLibrary*)photoLibrary{
    if(!_photoLibrary){
        _photoLibrary = [[PHPhotoLibrary alloc] init];
    }
    
    return _photoLibrary;
}

- (void)saveImage:(UIImage *)image toAlbum:(NSString *)album completionHandler:(ManagerSaveHandler)completionHandler{
    [self.photoLibrary writeImage:image toAlbum:album completionHandler:^(UIImage *image,NSError *error){
        if(completionHandler){
            completionHandler(image,error);
        }
        self.photoLibrary = nil;
    }];
    
    [self.photoLibrary add]
    
}

@end
