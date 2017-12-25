//
//  ERJSManager.m
//  ERJSManager
//
//  Created by 胡广宇 on 2017/12/25.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "ERJSManager.h"
#import <WebKit/WebKit.h>
#import "JSContextExportDelegate.h"

@interface ERJSManager ()<WKScriptMessageHandler, JSContextExportDelegate>
/** WKWebview */
@property (nonatomic, weak) WKWebView *wkWebview;
/** JS上下文对象 */
@property (nonatomic, weak) JSContext *jsContext;
/** JS代码 */
@property (nonatomic, copy) NSString *jsCode;

@end

@implementation ERJSManager

/**
 通过代理对象和WebView初始化JS管理对象
 
 @param webView WKWebView 或者 UIWebview
 @param delegate 代理对象
 @param jsCode 注入的js代码
 @return instancetype
 */
- (instancetype)initWithWebView:(id)webView delegate:(id<JSManagerDelegate>)delegate jsCode:(NSString *)jsCode{
    if (self = [super init]) {
        self.delegate = delegate;
        self.jsCode = jsCode;
        if ([webView isKindOfClass:[WKWebView class]]) {
            [self registWKWebViewJSContent:webView];
        }
    }
    return self;
}

- (void)registUIWebViewJSContent:(UIWebView *)uiWebView {
    //注入JS上下文
    self.jsContext = [uiWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
}


/**
 配置KWWebView JS回调

 @param wkWebview wkWebview
 */
- (void)registWKWebViewJSContent:(WKWebView *)wkWebview {
    
    _wkWebview = wkWebview;
    
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:self.jsCode injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKPreferences *preferences = [[WKPreferences alloc] init];
    
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    _wkWebview.configuration.preferences = preferences;
    
    [_wkWebview.configuration.userContentController addUserScript:userScript];
    
    [_wkWebview.configuration.userContentController addScriptMessageHandler:self name:self.jsCode];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if (message.body) {
        [self.delegate jsManager:self Call:message.body];
    }
}

#pragma mark - getter/setter
- (void)setJsContext:(JSContext *)jsContext {
    _jsContext = jsContext;

    jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    jsContext[self.jsCode] = self;
}

- (void)call:(id)parameter {
    [self.delegate jsManager:self Call:parameter];
}

/**
 移除JS回调，视图释放时必须要调用
 */
- (void)removeScriptMessageHandler{
    if (self.wkWebview) {
       [self.wkWebview.configuration.userContentController removeScriptMessageHandlerForName:self.jsCode];
    } else {
        self.jsContext = nil;
    }
}

@end
