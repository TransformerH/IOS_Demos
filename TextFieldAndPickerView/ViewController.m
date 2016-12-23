//
//  ViewController.m
//  TextFieldAndPickerView
//
//  Created by 韩雪滢 on 12/22/16.
//  Copyright © 2016 韩雪滢. All rights reserved.
//

#import "ViewController.h"
#import "ShowPickerViewTF.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet ShowPickerViewTF *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.arrayOne = @[@"Sheryl",@"Xiao",@"CS"];
    self.textView.arrayTwo = @[@"UCB",@"NYC",@"CMU"];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
