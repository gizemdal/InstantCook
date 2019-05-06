//
//  SignUp.swift
//  InstantCookProject
//
//  Created by Gizem Dal on 4/16/18.
//  Copyright © 2018 CIS195. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignUp: UIViewController {
    
    var reference: DatabaseReference!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func signUpBtn(_ sender: Any) {
        if (email.text != "" && password.text != "") {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
                if (user != nil) {
                    //Sign-in successful
                    print("Successful")
                    let placeholder = "none"
                    self.reference.child("Users").child((Auth.auth().currentUser?.uid)!).setValue(["username" : self.username.text!, "password" : self.password.text!, "email" : self.email.text!, "name" : self.name.text!, "ingredients" : placeholder, "recipes" : placeholder])
                    self.cancelBtn.setTitle("Done!", for: .normal)
                }
                else {
                    if let myError = error?.localizedDescription {
                        if (myError == "The email address is already in use by another account.") {
                            let alert = UIAlertController(title: "Uh Oh!", message: "The email address is already in use by another account, please try again!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                                NSLog("The \"OK\" alert occured.")
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else if (myError == "The password must be 6 characters long or more.") {
                            let alert = UIAlertController(title: "Uh Oh!", message: "The password must be 6 characters long or more, please find a longer password!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                                NSLog("The \"OK\" alert occured.")
                            }))
                            self.present(alert, animated: true, completion: nil)
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
        reference = Database.database().reference()
        cancelBtn.setTitle("Cancel", for: .normal)
    }
    

        // Do any additional setup after loading the view.

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        email.resignFirstResponder()
        password.resignFirstResponder()
        name.resignFirstResponder()
        username.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        email.resignFirstResponder()
        password.resignFirstResponder()
        name.resignFirstResponder()
        username.resignFirstResponder()
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
