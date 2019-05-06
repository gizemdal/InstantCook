//
//  PasswordReminder.swift
//  InstantCookProject
//
//  Created by Gizem Dal on 4/20/18.
//  Copyright © 2018 CIS195. All rights reserved.
//

import UIKit
import FirebaseAuth

class PasswordReminder: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBAction func resetPassword(_ sender: Any) {
        if (email.text != "") {
        Auth.auth().sendPasswordReset(withEmail: email.text!, completion: ({ (error) in
                if error?.localizedDescription == nil {
            self.statusText.text = "Successfully sent!"
                    self.cancelBtn.setTitle("Done!", for: .normal)
                }
                else {
                    self.statusText.text = "There is no user with this email. Please try again!"
                }
            }))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        statusText.text = ""
        cancelBtn.setTitle("Cancel", for: .normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        email.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        email.resignFirstResponder()
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
