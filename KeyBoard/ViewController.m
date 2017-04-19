//
//  ViewController.m
//  KeyBoard
//
//  Created by 韩雪滢 on 4/10/17.
//  Copyright © 2017 韩雪滢. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()



@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *viewTry;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLC;
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTap:)];
    [self.view addGestureRecognizer:singleTap];
}

- (void)fingerTap:(UITapGestureRecognizer*)gestureRecognizer{
    [self.view endEditing:YES];
}

-(void)keyboardAppear:(NSNotification *)aNotification
{
    NSDictionary * userInfo = aNotification.userInfo;
    CGRect frameOfKeyboard = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame = self.view.frame;
    
    CGRect vFrame = self.viewTry.frame;
    
    CGFloat height = frame.size.height - frameOfKeyboard.origin.y;//加64是因为存在navigation导致view本身就整体下移了64个单位
    self.viewTry.frame = CGRectMake(vFrame.origin.x, height, vFrame.size.width, vFrame.size.height);
    
//    self.bottomLC.constant = height;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
