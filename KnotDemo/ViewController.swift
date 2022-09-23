//
//  ViewController.swift
//  KnotDemo
//
//  Created by TARIK AIT MBAREK on 14/8/2022.
//

import UIKit
import KnotAPI

class ViewController: UIViewController, CardOnFileDelegate {
    func onSuccess(merchant: String) {
        print(merchant)
    }

    func onError(error: String, message: String) {
        print(error)
        print(message)
    }
    func onEvent(event: String, message: String) {
        print(event)
        print(message)
    }
    func onExit() {
        print("onExit event")
    }
    func onFinished() {
        print("onFinished event")
    }
    
    var session: CardOnFileSwitcherSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        // Do any additional setup after loading the view.
    }


    @IBAction func openAccountUpdater() {
        let session = CardOnFileSwitcherSession(sessionId: "9c361eed-f86c-4db7-8adb-92caca93f8d9", clientId: "ab86955e-22f4-49c3-97d7-369973f4cb9e", environment: .sandbox)
        session.setPrimaryColor(primaryColor: "#000000")
        session.setTextColor(textColor: "#FFFFFF")
        session.setCompanyName(companyName: "Rho")
        session.openOnCardFileSwitcher(merchants: [])
        session.setDelegate(delegate: self)
    }
}

