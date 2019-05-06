//
//  Login.swift
//  InstantCookProject
//
//  Created by Gizem Dal on 4/14/18.
//  Copyright © 2018 CIS195. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class Login: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var reference: DatabaseReference!
    var validUser: Bool!
    
    @IBAction func loginBtn(_ sender: Any) {
        if (email.text != "" && password.text != "") {
            Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
                if (user != nil) {
                   //Sign-in successful
                    self.validUser = true
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
                else {
                    if let myError = error?.localizedDescription {
                        if (myError == "The email address is badly formatted.") {
                            let alert = UIAlertController(title: "Uh Oh!", message: "The email address is badly formatted, please try again!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                                NSLog("The \"OK\" alert occured.")
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else if (myError == "There is no user record corresponding to this identifier. The user may have been deleted.") {
                            let alert = UIAlertController(title: "Uh Oh!", message: "There is no user with the given email address. Make sure that you're entering the correct email address!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                                NSLog("The \"OK\" alert occured.")
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else if (myError == "The password is invalid or the user does not have a password.") {
                            let alert = UIAlertController(title: "Uh Oh!", message: "The entered password is incorrect, please try again!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                                NSLog("The \"OK\" alert occured.")
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else {
                            self.showAlert()
                        }
                    }
                    else {
                        print("Error")
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        validUser = false
        reference = Database.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        email.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        email.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Uh Oh!", message: "There is no user with the given information. Make sure that your email is well formed and your password is correct!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
