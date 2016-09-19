//
//  Manager.h
//  PickFromPhotos
//
//  Created by 韩雪滢 on 9/18/16.
//  Copyright © 2016 韩雪滢. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class UIImage;

typedef void (^ManagerSaveHandler)(UIImage *image,NSError *error);
extern void ManagerWriteToPhotoAlbum(UIImage *image,NSString *album,ManagerSaveHandler completionHandler);

@interface Manager : NSObject

+ (instancetype)sharedManager;
- (void)saveImage:(UIImage*)image toAlbum:(NSString*)album completionHandler:(ManagerSaveHandler)completionHandler;

@end
