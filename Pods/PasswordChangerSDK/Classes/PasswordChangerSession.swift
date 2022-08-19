//
// Created by TARIK AIT MBAREK on 8/8/2022.
//

import Foundation

public typealias CompletionHandler = (String) -> Void

struct Session: Decodable {
    let session_id: String
}

public class PasswordChangerSession {

    public init() {}

    var sessionId: String = ""

    public func createSession(completionHandler: @escaping CompletionHandler) {
        let url = URL(string: "https://api.knotapi.com/api/session")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }

            // Check if Error took place

            if let error = error {

                print("Error took place \(error)")

                return

            }



            // Read HTTP Response Status code

            if let response = response as? HTTPURLResponse {

                print("Response HTTP Status code: \(response.statusCode)")

            }
            //convert HTTP data - json to struct

            let decoder = JSONDecoder()

            do {

                if let session = try? JSONDecoder().decode(Session.self, from: data) {
                    self.sessionId = session.session_id
                } else {
                    print("Invalid Response")
                }
            } catch {
                print(error.localizedDescription)
            }
            print(String(data: data, encoding: .utf8)!)
            completionHandler(self.sessionId)
        }
        task.resume()
    }
}