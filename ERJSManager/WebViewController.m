//
//  WebViewController.m
//  ERJSManager
//
//  Created by 胡广宇 on 2017/12/25.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "ERJSManager.h"

@interface WebViewController ()<WKNavigationDelegate, WKUIDelegate, UIWebViewDelegate, JSManagerDelegate>

@property (nonatomic, strong) UIWebView *uiWebView;

@property (nonatomic, strong) WKWebView *wkWebView;

@property (nonatomic, strong) ERJSManager *jsManager;

@end

@implementation WebViewController

- (void)dealloc {
    [self.jsManager removeScriptMessageHandler];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //二选一
//    [self loadWKWebView];
    
    [self loadUIWebView];
    
    [self setupDismissBtn];
}

- (void)loadUIWebView {
    /**
     我的理解：
        对于UIWebView来说 需要JSContext来入监听JS回调（当然不止这一种方法），这里的jsCode可以写成静态的死的，看前端同学怎么设计了。
        通常情况下，jsCode就叫app，对于前端来说一看window.app就代表着需要与app进行交互，一目了然，所以用window.app.functionName来调用（这个方法同样适用于Android的webView）
        而functionName部分就是对应的iOS或者Android端的方法名
     */
    [self.uiWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"demo" ofType:@"html"]]]];
    self.jsManager = [[ERJSManager alloc] initWithWebView:self.uiWebView delegate:self jsCode:@"app"];
}

- (void)loadWKWebView {
    /**
     我的理解：
     对于WKWebView来说，可以使用WKWebViewConfiguration来配置JS回调，，这里的jsCode是否写死同样也看前端同学怎么设计，但WKWebView回调很方便理解
     只要web端用js调用方法，iOS端就可以收到消息
     但是对于WKWebView，在web端调用js的方法叫：window.webkit.messageHandlers.app.postMessage()，
     这就UIWebView和Android端不一样了，这很头疼，前端需要再写一段Android的JS代码，也就是上面UIWebView的方法
     */
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"demo" ofType:@"html"]]]];
    self.jsManager = [[ERJSManager alloc] initWithWebView:self.wkWebView delegate:self jsCode:@"app"];// jsCode 是与web端确定好的回调标识
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.jsManager registUIWebViewJSContent:webView];
}

#pragma mark - JSManagerDelegate

- (void)jsManager:(ERJSManager *)jsManager Call:(id)parameter{
    NSLog(@"%@", parameter);
}

- (void)setupDismissBtn {
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *disBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 40, 80, 20)];
    [disBtn setTitle:@"dismiss" forState:UIControlStateNormal];
    [disBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [disBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:disBtn];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter/setter

- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:self.view.frame];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        [self.view addSubview:_wkWebView];
    }
    return _wkWebView;
}

- (UIWebView *)uiWebView {
    if (!_uiWebView) {
        _uiWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
        _uiWebView.delegate = self;
        _uiWebView.userInteractionEnabled = YES;
        [self.view addSubview:_uiWebView];
    }
    return _uiWebView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
