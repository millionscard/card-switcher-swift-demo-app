//
//  ViewController.swift
//  KnotDemo
//
//  Created by TARIK AIT MBAREK on 14/8/2022.
//

import UIKit
import KnotAPI

class ViewController: UIViewController {
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
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
    }


    @IBAction func openAccountUpdater() {
        let session = CardOnFileSwitcherSession(sessionId: "faf88aa3-3508-4b78-96dd-776c24443dd9", clientId: "03d4b1a7-2799-4c2d-84be-92191008451c", environment: .sandbox)
        session.setPrimaryColor(primaryColor: "#000000")
        session.setTextColor(textColor: "#FFFFFF")
        session.setCompanyName(companyName: "Rho")
        session.openCardOnFileSwitcher()
//        session.setDelegate(delegate: self)
    }
}

