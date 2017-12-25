//
//  ERJSManager.h
//  ERJSManager
//
//  Created by 胡广宇 on 2017/12/25.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIWebView;
@protocol JSManagerDelegate;

@interface ERJSManager : NSObject

@property (nonatomic, weak) id<JSManagerDelegate> delegate;

/**
 通过代理对象和WebView初始化JS管理对象

 @param webView WKWebView 或者 UIWebview
 @param delegate 代理对象
 @param jsCode 注入的js代码
 @return instancetype
 */
- (instancetype)initWithWebView:(id)webView delegate:(id<JSManagerDelegate>)delegate jsCode:(NSString *)jsCode;

/**
 移除JS回调，视图释放时必须要调用， 否则本类将无法释放
 */
- (void)removeScriptMessageHandler;


/**
 UIWebView需要在webViewDidFinishLoad中调用该方法以注入JS

 @param uiWebView UIWebView
 */
- (void)registUIWebViewJSContent:(UIWebView *)uiWebView;

@end

@protocol JSManagerDelegate <NSObject>

@required

/**
 js回调
 @param parameter 回调参数
 */
- (void)jsManager:(ERJSManager *)jsManager Call:(id)parameter;

@end
