//
//  AuthManager.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 5/27/24.
//

import Foundation
import LocalAuthentication

class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    func logIn(account: String, passphrase: String, completion: @escaping (Bool) -> Void) {
        if account == Secrets.accountName && passphrase == Secrets.accountPassword {
            UserDefaults.standard.set(true, forKey: "hasLoggedIn")
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func authenticate(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Quickly log in to TicketCatcher."
            
            if UserDefaults.standard.bool(forKey: "hasLoggedIn") && UserDefaults.standard.bool(forKey: "canAndMustUseFaceID") {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    completion(success)
                }
            } else {
                completion(false)
            }
        } else {
            completion(false)
        }
    }
}
