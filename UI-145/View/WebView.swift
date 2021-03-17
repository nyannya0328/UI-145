//
//  WebView.swift
//  UI-145
//
//  Created by にゃんにゃん丸 on 2021/03/17.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var url : URL
    func makeUIView(context: Context) -> WKWebView {
        
        let view = WKWebView()
        view.load(URLRequest(url: url))
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}
