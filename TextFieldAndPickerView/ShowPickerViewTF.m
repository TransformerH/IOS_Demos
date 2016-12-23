//
//  ShowPickerViewTF.m
//  TextFieldAndPickerView
//
//  Created by 韩雪滢 on 12/22/16.
//  Copyright © 2016 韩雪滢. All rights reserved.
//

#import "ShowPickerViewTF.h"

@implementation ShowPickerViewTF{
    UIToolbar *inputAccessoryView;
    NSString *resultString;
    NSString *pickerOneString;
    NSString *pickerTwoString;
}

@synthesize arrayOne;
@synthesize arrayTwo;


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){}
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 120)];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    self.inputView = pickerView;
    
    pickerOneString = @"";
    pickerTwoString = @"";
}


- (void)setSelectRow:(NSInteger)index{
    if(index >= 0){
        [pickerView selectRow:index inComponent:0 animated:YES];
    }
}


#pragma mark - UIPickerView dataSource, delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *selectString;
    
    if(component == 0){
        selectString = arrayOne[row];
    }else if(component == 1){
        selectString = arrayTwo[row];
    }
    
    return selectString;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger rowN = 0;
    
    if(component == 0)
        rowN = arrayOne.count;
    else if(component == 1)
        rowN = arrayTwo.count;
    return rowN;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if(component == 0){
        pickerOneString = arrayOne[row];
    }
    else if(component == 1){
        
        if(![pickerOneString isEqualToString:@""]){
            pickerTwoString = arrayTwo[row];
        }
    }
    
    if(![pickerTwoString isEqualToString:@""]){
        resultString = [[NSString alloc] initWithFormat:@"%@-%@",pickerOneString,pickerTwoString];
    }
}

#pragma mark - inputAccessoryView with toolbar
- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)done:(id)sender{
    
    self.text = resultString;
    
    [self resignFirstResponder];
    [super resignFirstResponder];
}

- (UIView*)inputAccessoryView{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return nil;
    }else{
        if(!inputAccessoryView){
            inputAccessoryView = [[UIToolbar alloc] init];
            inputAccessoryView.barStyle = UIBarStyleBlackTranslucent;
            inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            [inputAccessoryView sizeToFit];
            CGRect frame = inputAccessoryView.frame;
            frame.size.height = 30.0f;
            inputAccessoryView.frame = frame;
            
            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
            UIBarButtonItem *flexbleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            
            NSArray *array = [NSArray arrayWithObjects:flexbleSpaceLeft,doneBtn, nil];
            [inputAccessoryView setItems:array];
        }
        
        return inputAccessoryView;
        
    }
}

@end
