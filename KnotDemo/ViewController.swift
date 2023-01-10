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
    var session: CardOnFileSwitcherSession!
    
    enum isCallFrom {
        case switcher
        case canceller
        case none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
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
        var parameters: [String: Any] = [String: Any]()
        if(isOpenFrom == .switcher){
            parameters = [ "type": "card_switcher" ]
        }else{
            parameters = [ "type": "subscription_canceller" ]
        }
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
                            let session = CardOnFileSwitcherSession(sessionId: sessionID, clientId: "3f4acb6b-a8c9-47bc-820c-b0eaf24ee771", environment: .sandbox)
                            session.setPrimaryColor(primaryColor: "#000000")
                            session.setTextColor(textColor: "#FFFFFF")
                            session.setCompanyName(companyName: "Rho")
                            let cardSwitcherConfig = CardSwitcherConfiguration()
                            cardSwitcherConfig.setOnSuccess(onSuccess: {merchant in
                                print("cardSwitcher Merchant: \(merchant)")
                            })
                            cardSwitcherConfig.setOnExit {
                                print("cardSwitcher onExit")
                            }
                            cardSwitcherConfig.setOnError { error, message in
                                print("cardSwitcher Error: \(error), Message: \(message)")
                            }
                            cardSwitcherConfig.setOnEvent(onEvent: { event, merchant in
                                print("cardSwitcher Event: \(event), Merchant: \(merchant)")
                            })
                            cardSwitcherConfig.setOnFinished {
                                print("cardSwitcher Finished")
                            }
                            session.setConfiguration(config: cardSwitcherConfig)
                            DispatchQueue.main.async {
                                session.openCardOnFileSwitcher()
                            }
                        }
                        else {
                            let session = SubscriptionCancelerSession(sessionId: sessionID, clientId: "3f4acb6b-a8c9-47bc-820c-b0eaf24ee771", environment: .sandbox)
                            session.setPrimaryColor(primaryColor: "#000000")
                            session.setTextColor(textColor: "#FFFFFF")
                            session.setCompanyName(companyName: "Millions")
                            session.setAmount(amount: true)
                            let config = SubscriptionCancelerConfiguration()
                            config.setOnSuccess { merchant in
                                print("SubscriptionCanceler onSuccess Merchant: \(merchant)")
                            }
                            config.setOnExit {
                                print("SubscriptionCanceler onExit")
                            }
                            config.setOnError { error, message in
                                print("SubscriptionCanceler Error: \(error), Message: \(message)")
                            }
                            config.setOnEvent(onEvent: { event, merchant in
                                print("SubscriptionCanceler Event: \(event), Merchant: \(merchant)")
                            })
                            config.setOnFinished {
                                print("SubscriptionCanceler Finished")
                            }
                            session.setConfiguration(configuration: config)
                            DispatchQueue.main.async {
                                session.openSubscriptionCanceler()
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}

