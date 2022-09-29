//
//  ViewController.swift
//  KnotDemo
//
//  Created by TARIK AIT MBAREK on 14/8/2022.
//

import UIKit
import KnotAPI

class ViewController: UIViewController {
    
    //MARK: - OBJECT
    var isOpenFrom : isCallFrom = .none
    
    enum isCallFrom {
        case switcher
        case canceller
        case none
    }

    //MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
    }

    //MARK: - BTN ACTION
    @IBAction func onClick(_ sender: UIButton) {
        if sender.tag == 1 {
            isOpenFrom = .switcher
        }
        else {
            isOpenFrom = .canceller
        }
        self.apiCallRegister()
    }
}

//MARK: - API CALL METHODS
extension ViewController {
    
    func apiCallRegister(){
        let Url = String(format: "https://sample.knotapi.com/api/register")
        let parameters: [String: Any] = [
            "first_name": "Nikunj",
            "last_name": "Patel",
            "email": "production@knotapi.com",
            "phone_number": "+18024687679",
            "password": "password",
            "address1": "348 W 57th St",
            "address2": "#367",
            "state": "NY",
            "city": "New York",
            "postal_code": "10019"
        ]
        self.apicall(Url: Url, parameters: parameters, token: "")
    }
    
    func apiCallCreateSession(token:String){
        let Url = String(format: "https://sample.knotapi.com/api/knot/session")
        let parameters: [String: Any] = [String: Any]()
        self.apicall(Url: Url, parameters: parameters, token: token)
    }
    
    func apicall(Url:String , parameters:[String:Any] , token:String ){
        guard let serviceUrl = URL(string: Url) else { return }
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.httpBody = httpBody
        request.setValue("sandbox", forHTTPHeaderField: "Environment")
        request.setValue("ab86955e-22f4-49c3-97d7-369973f4cb9e", forHTTPHeaderField: "Client-Id")
        request.setValue("d1a5cde831464cd3840ccf762f63ceb7", forHTTPHeaderField: "Client-Secret")
        if token == "" {
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        }
        else {
            request.setValue(("Bearer \(token)"), forHTTPHeaderField: "Authorization")
        }
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    if token == "" {
                        let resToken = (json as? NSDictionary ?? NSDictionary())["token"] as? String ?? ""
                        self.apiCallCreateSession(token: resToken)
                    }
                    else {
                        let sessionID = (json as? NSDictionary ?? NSDictionary())["session"] as? String ?? ""
                        if self.isOpenFrom == .switcher {
                            let session = CardOnFileSwitcherSession(sessionId: sessionID, clientId: "ab86955e-22f4-49c3-97d7-369973f4cb9e", environment: .sandbox)
                            session.setPrimaryColor(primaryColor: "#000000")
                            session.setTextColor(textColor: "#FFFFFF")
                            session.setCompanyName(companyName: "Rho")
                            session.openOnCardFileSwitcher(merchants: [])
                            session.setDelegate(delegate: self)
                        }
                        else {
                            let session = CardOnFileSwitcherSession(sessionId: sessionID, clientId: "ab86955e-22f4-49c3-97d7-369973f4cb9e", environment: .sandbox)
                            session.setPrimaryColor(primaryColor: "#000000")
                            session.setTextColor(textColor: "#FFFFFF")
                            session.setCompanyName(companyName: "Millions")
                            session.openOnSubscriptionCanceler(merchants: [])
                            session.setDelegate(delegate: self)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}

//MARK: - DELEGATE METHODS
extension ViewController : CardOnFileDelegate {
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
}
