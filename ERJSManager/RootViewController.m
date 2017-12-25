//
//  RootViewController.m
//  ERJSManager
//
//  Created by 胡广宇 on 2017/12/25.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "RootViewController.h"
#import "WebViewController.h"

@interface RootViewController ()


@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 200) / 2, 500, 200, 40)];
    [btn setTitle:@"goWebViewController" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gotoWebViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)gotoWebViewController {
    [self presentViewController:[[WebViewController alloc] init] animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
