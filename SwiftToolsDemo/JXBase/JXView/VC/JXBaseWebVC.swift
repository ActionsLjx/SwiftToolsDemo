//
//  JXBaseWebVC.swift
//  NasiLive2th
//
//  Created by ken Z on 2023/5/8.
//

import UIKit

import UIKit
import WebKit
import SnapKit

class WebProcessPool: WKProcessPool {
    class var sharedProcessPool: WebProcessPool {
        struct Static {
            static let instance: WebProcessPool = WebProcessPool()
        }
        return Static.instance
    }
    
}

class JXBaseWebVC: JXBaseVC {
    
    var topUrl:String?
    var isNaviBarHidden = false
    var titleStr:String = ""
    var isShowBackBtn = true
    var htlmString:String?
    // MARK: 生命周期
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = isNaviBarHidden
        self.tabBarController?.tabBar.isHidden = true
        self.showGobackBtn()
        self.configNaviBarDefault()
        self.title = titleStr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        configWebView()
    }
    
    private func configWebView() {
        self.view.addSubview(self.progress)
        self.webView.autoresizingMask = .flexibleHeight
        self.webView.scrollView.bounces = false
        self.webView.backgroundColor = UIColor.white
        self.webView.isHidden = false
        if let htlmString = htlmString{
            webView.loadHTMLString(htlmString, baseURL: nil)
        }
        if let topUrl = topUrl,
           let url = URL(string: topUrl){
            self.webView.load(URLRequest.init(url: url))
        }
        self.webView.scrollView.contentInsetAdjustmentBehavior = .never
        self.view.addSubview(self.webView)
    }
    
    // MARK: 懒加载
    lazy var webView:WKWebView = {
        let webView = WKWebView.init(frame: CGRect.init(x: 0, y: 2, width: kScreenWidth, height: kScreenHeight-2), configuration: self.config)
        webView.allowsBackForwardNavigationGestures = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        return webView
    }()
    
    private lazy var progress:UIProgressView = {
        let view = UIProgressView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 2))
        return view
    }()
    
    private lazy var config:WKWebViewConfiguration = {
        let config = WKWebViewConfiguration.init()
        config.allowsPictureInPictureMediaPlayback = true
        config.allowsInlineMediaPlayback = true
        let preference = WKPreferences()
        config.preferences = preference
        //允许native与js交互
        preference.javaScriptEnabled = true
        config.allowsAirPlayForMediaPlayback = true
        config.processPool = WebProcessPool.sharedProcessPool
        let userContentController = WKUserContentController()
        config.userContentController = userContentController
        userContentController.add(self,name: "popWebView")
        config.userContentController = userContentController
        return config
    }()
}

extension JXBaseWebVC:WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "popWebView"){
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let authenticationMethod = challenge.protectionSpace.authenticationMethod
        if authenticationMethod == NSURLAuthenticationMethodDefault || authenticationMethod == NSURLAuthenticationMethodHTTPBasic || authenticationMethod == NSURLAuthenticationMethodHTTPDigest {
            completionHandler(.useCredential,nil)
        }else if authenticationMethod == NSURLAuthenticationMethodServerTrust{
            // needs this handling on iOS 9
            let card = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.performDefaultHandling, card);
        }else{
            completionHandler(.cancelAuthenticationChallenge, nil);
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if (self.view.viewWithTag(12) == nil) {
            self.view.addSubview(webView)
            webView.snp.updateConstraints({ (make) in
                make.left.right.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            })
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(WKNavigationResponsePolicy.allow)
        
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo) async {
        
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo) async -> String? {
        return ""
    }
    

}
