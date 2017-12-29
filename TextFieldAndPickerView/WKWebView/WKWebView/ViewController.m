//
//  ViewController.m
//  WKWebView
//
//  Created by XN0O0I on 16/10/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()
@property(nonatomic,strong)WKWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [[NSURL alloc] initWithString:@"http://www.baidu.com"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}


- (WKWebView *)webView
{
    if (_webView == nil)
    {
        _webView = [[WKWebView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
