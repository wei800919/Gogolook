//
//  AnimeDetailViewController.swift
//  GogolookTest
//
//  Created by Xidi on 2022/2/28.
//

import UIKit
import WebKit

class AnimeDetailViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var webView = WKWebView()
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            let configuration = WKWebViewConfiguration()
            configuration.allowsInlineMediaPlayback = false
            
            webView = WKWebView(frame: UIScreen.main.bounds, configuration: configuration)
            webView.navigationDelegate = self
            webView.uiDelegate = self
            webView.load(request)
            self.view.addSubview(webView)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backBarButtonAction(_ sender: Any) {
        if self.webView.canGoBack {
            self.webView.goBack()
            return
        }
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func closeBarButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(webView.url ?? "")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(webView.url ?? "")
        self.title = webView.title
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(webView.url ?? "")
        print(error)
    }
}
