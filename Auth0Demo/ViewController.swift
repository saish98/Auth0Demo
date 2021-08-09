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
                        print("Success: \(credentials.description)")
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                    }
                }
        }
    }
}

