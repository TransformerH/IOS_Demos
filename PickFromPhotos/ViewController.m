//
//  ViewController.m
//  PickFromPhotos
//
//  Created by 韩雪滢 on 9/18/16.
//  Copyright © 2016 韩雪滢. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *img = [UIImage imageNamed:@"saveImg"];
    
  //  仅保存图片到系统相册
  //  [self saveInAlbum:img];
  //  保存图片到自定义相册
    [self saveInSelfAlbum];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-----------------------------------  保存图片到系统相册
- (void)saveInAlbum:(UIImage*)img{
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    NSString *msg = nil;
    if(error != nil){
        msg = @"保存图片失败";
    }else{
        msg = @"保存图片成功";
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"⚠️" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消⚠️");
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


//====================================  保存图片到自定义相册

- (void)saveInSelfAlbum{
    __block NSString *assetId = nil;
    //图片存储到  相机胶卷
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        assetId = [PHAssetCreationRequest creationRequestForAssetFromImage:[UIImage imageNamed:@"saveImg"]].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if(error){
            NSLog(@"保存到相机胶卷失败");
            return;
        }
        
        NSLog(@"保存到相机胶卷成功");
        
        //获取创建的相册对象
        PHAssetCollection *collection = [self collection];
        
        //将 相机胶卷 中的照片存到新的相册
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
            //根据唯一标识获得相片对象
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].firstObject;
            [request addAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
            NSString *msg = [[NSString alloc] init];
            
            if(error){
                NSLog(@"添加到自定义相册失败");
                return;
            }
            
            msg = @"添加到自定义相册成功";
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"⚠️" message:msg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击取消⚠️");
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }];
        
    }];
}

//创建自定义相册
- (PHAssetCollection*)collection{
    PHFetchResult<PHAssetCollection*> *collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for(PHAssetCollection *collection in collectionResult){
        if([collection.localizedTitle isEqualToString:@"PickFromPhotos"]){
            return collection;
        }
    }
    //自定义相册不存在
    __block NSString *collectionId = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        //创建一个新相册
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"PickFromPhotos"].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].firstObject;
    
}


@end
