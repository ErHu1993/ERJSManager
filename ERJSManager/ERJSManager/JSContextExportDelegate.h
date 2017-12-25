//
//  JSContentExportDelegate.h
//  ERJSManager
//
//  Created by 胡广宇 on 2017/12/25.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSContextExportDelegate <JSExport>

/**
 该类只在UIWebView注入JSContext时使用，方法名叫call，与web端约定好
 
 @param parameter 回调参数
 */
- (void)call:(id)parameter;

@end
