//
//  PasswordChangerViewController.swift
//  PasswordChangerSDK-PasswordChangerSDK
//
//  Created by TARIK AIT MBAREK on 2/8/2022.
//

import UIKit
import WebKit
import os

public class PasswordChangerViewController: UIViewController, WKScriptMessageHandler {
    var webView: WKWebView!
    var successWebHandler : String = "success"
    var closeWebHandler : String = "close"
    var errorWebHandler : String = "error"
    var socketWebHandler : String = "socketEvent"
    var sessionId: String

    public init(sessionId: String) {
        self.sessionId = sessionId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    public override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        let contentController = WKUserContentController()

        let userScript: WKUserScript = WKUserScript(source: "window.sessionId = \"\(sessionId)\"", injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        webView.configuration.userContentController = contentController
        webView.configuration.userContentController.add(self, name: successWebHandler)
        webView.configuration.userContentController.add(self, name: errorWebHandler)
        webView.configuration.userContentController.add(self, name: closeWebHandler)
        webView.configuration.userContentController.add(self, name: socketWebHandler)
        webView.configuration.userContentController.addUserScript(userScript)

        view = webView
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        modalPresentationStyle = .fullScreen
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let url = URL(string: "https://password-changer-web.vercel.app/")
        webView.load(URLRequest(url: url!))
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case successWebHandler:
            onSuccess()
        case errorWebHandler:
            onError()
        case closeWebHandler:
            onClose()
        case socketWebHandler:
            print(message.body as! String)
        default:
            print("no message handler")
        }
    }
    
    private func onError(){
        print("error")
    }
    
    private func onClose(){
        dismiss(animated: true)
    }
    
    private func onSuccess(){
        print("success")
    }
}
