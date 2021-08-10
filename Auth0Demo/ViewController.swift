//
//  ViewController.swift
//  Auth0Demo
//
//  Created by Saish Chachad on 09/08/21.
//

import UIKit
import Auth0

class ViewController: UIViewController {

    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet private weak var textFieldPassword: UITextField!
    
    fileprivate var retrievedCredentials: Credentials?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func buttonLoginAction(_ sender: Any) {
        let auth = Auth0
            .authentication(clientId: "", domain: "")
        
        // keychain
        var credentialManager = CredentialsManager.init(authentication: auth)

        Auth0
            .authentication()
            .login(
                usernameOrEmail: self.textFieldEmail.text!,
                password: self.textFieldPassword.text!,
                realm: "Username-Password-Authentication",
                scope: "openid profle offline_access")
            .start { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let credentials):
                        self.retrievedCredentials = credentials
                        credentialManager.store(credentials: credentials)
                        credentialManager.enableBiometrics(withTitle: "For security", cancelTitle: "Not Now", fallbackTitle: "?", evaluationPolicy: .deviceOwnerAuthenticationWithBiometrics)
                        print("Success: \(credentials.description)")
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                    }
                }
        }
        
        
        // Logout
        _ = credentialManager.clear()
        
    }
    
    private func retrieveCredentials() {
        let auth = Auth0
            .authentication(clientId: "", domain: "")
        
        // keychain
        let credentialManager = CredentialsManager.init(authentication: auth)

        // Check if session is valid
        if credentialManager.hasValid() {
            // if yes fetch credentials
            credentialManager.credentials { error, credentials in
                // renew token
                let request = auth.renew(withRefreshToken: credentials?.refreshToken ?? "", scope: "openid profile offline_access").start { newCreds in
                    // store new credentials
                    credentialManager.store(credentials: try! newCreds.get())
                }
                
            }
        } else {
            // logout 
            credentialManager.clear()
            // login again
        }
    }
}

