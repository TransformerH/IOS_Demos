//
//  PickFromPhotoVC.m
//  GetFromPhotos
//
//  Created by 韩雪滢 on 9/19/16.
//  Copyright © 2016 韩雪滢. All rights reserved.
//

#import <Photos/Photos.h>
#import "PickFromPhotoVC.h"

@interface PickFromPhotoVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,assign) ClipperType clipperType;
@property (weak, nonatomic) IBOutlet UIImageView *showImg;

@end

@implementation PickFromPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pickAction:(id)sender {
    
    //------------------------------------  UIAlertControllerSheet
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.clipperType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self pickPhoto:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"📷" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.clipperType = UIImagePickerControllerSourceTypeCamera;
        [self pickPhoto:UIImagePickerControllerSourceTypeCamera];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)pickPhoto:(UIImagePickerControllerSourceType)type{
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    
    //------------------------  确定照片的来源是相册／拍照
    imgPicker.sourceType = type;
    
    imgPicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    imgPicker.allowsEditing = YES;
    [self presentViewController:imgPicker animated:YES completion:nil];
    
}


//-------------------------------  实现ImagePickerController的代理方法

#pragma mark - UIImagePickerControllerdelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //系统方式裁剪
    NSString *imgKey = UIImagePickerControllerEditedImage;
    UIImage *image = [info objectForKey:imgKey];
    
    //--------------------------------------  自动保存裁剪完的相片到自定义相册
    [self saveInSelfAlbum:image];
    
    self.showImg.image = [self OriginImage:[info objectForKey:imgKey] scaleToSize:self.showImg.bounds.size];
    
    // －－－－－－－－－－－－－－－－－－－－－－ 显示完自动退出
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}

//让image自适应image View的大小
-(UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)saveInSelfAlbum:(UIImage*)saveImg{
    __block NSString *assetId = nil;
    //图片存储到  相机胶卷
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        assetId = [PHAssetCreationRequest creationRequestForAssetFromImage:saveImg].placeholderForCreatedAsset.localIdentifier;
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
                msg = @"添加到自定义相册失败";
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
        if([collection.localizedTitle isEqualToString:@"cutPhotos"]){
            return collection;
        }
    }
    //自定义相册不存在
    __block NSString *collectionId = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        //创建一个新相册
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"cutPhotos"].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].firstObject;
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
