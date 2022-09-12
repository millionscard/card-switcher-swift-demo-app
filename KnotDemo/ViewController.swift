//
//  ViewController.swift
//  KnotDemo
//
//  Created by TARIK AIT MBAREK on 14/8/2022.
//

import UIKit
import KnotAPI

class ViewController: UIViewController {
    var session: CardOnFileSwitcherSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func openAccountUpdater() {
        let session = CardOnFileSwitcherSession(sessionId: "e64b25c2-d307-41bf-abc1-d3dd1803e2f2")
        session.openOnCardFileSwitcher(merchants: [])
    }
}

