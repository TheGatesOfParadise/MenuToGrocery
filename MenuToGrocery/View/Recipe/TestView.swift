//show webview from url
//https://medium.com/geekculture/how-to-use-webview-in-swiftui-and-also-detect-the-url-21d4fab2a9c1

import SwiftUI
import WebKit

struct Content1View: View {
    
    @State var showWebView = false
    
    var body: some View {
        Button {
            showWebView.toggle()
        } label: {
            Text("Open WebView")
        }
        .fullScreenCover(isPresented: $showWebView){
            WebView(url: URL(string: "https://www.appcoda.com")!, showWebView: $showWebView)
        }
    }
}

struct WebView: UIViewRepresentable {
 
    var url: URL
    @Binding var showWebView: Bool
 
    func makeUIView(context: Context) -> WKWebView {
        let wKWebView = WKWebView()
        wKWebView.navigationDelegate = context.coordinator
        return wKWebView
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(self)
    }
    
    class WebViewCoordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            let urlToMatch = "https://workshop.appcoda.com/"
            if let urlStr = navigationAction.request.url?.absoluteString, urlStr == urlToMatch {
                parent.showWebView = false
            }
            decisionHandler(.allow)
        }
        
    }
}

struct Content1_Previews: PreviewProvider {
    static var previews: some View {
        Content1View()
    }
}
