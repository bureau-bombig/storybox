//
//  WebView.swift
//  Storybox
//
//  Created by User on 12.05.24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let htmlContent: String
    let baseURL: URL?
    @Binding var scrollUp: Bool
    @Binding var scrollDown: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if webView.url == nil {
            webView.loadHTMLString(htmlContent, baseURL: baseURL)
        }
        
        if scrollUp {
            print("WebView: scroll up")
            webView.evaluateJavaScript("window.scrollBy(0, -100);") { _, _ in
                DispatchQueue.main.async {
                    self.scrollUp = false
                }
            }
        }
        
        if scrollDown {
            print("WebView: scroll down")
            webView.evaluateJavaScript("window.scrollBy(0, 100);") { _, _ in
                DispatchQueue.main.async {
                    self.scrollDown = false
                }
            }
        }
    }
}
