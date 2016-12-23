//
//  ShowPickerViewTF.h
//  TextFieldAndPickerView
//
//  Created by 韩雪滢 on 12/22/16.
//  Copyright © 2016 韩雪滢. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowPickerViewTF : UITextField<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *pickerView;
}

@property (nonatomic,strong) NSArray *arrayOne;
@property (nonatomic,strong) NSArray *arrayTwo;

- (void)setSelectRow:(NSInteger)index;

@end
