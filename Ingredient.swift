//
//  Ingredient.swift
//  InstantCookProject
//
//  Created by Gizem Dal on 4/5/18.
//  Copyright © 2018 CIS195. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class Ingredient: UIViewController {

    @IBOutlet weak var checkboxText: UILabel!
    @IBOutlet weak var checkbox: UIImageView!
    @IBOutlet weak var type: UISegmentedControl!
    @IBOutlet weak var amount: UILabel!
    @IBAction func type(_ sender: UISegmentedControl) {
        let selected = sender.selectedSegmentIndex
        if (selected == 0) {
            amount.text = String("\(Int(slider.value)) oz.")
        }
        else {
            amount.text = String(Int(slider.value))
        }
    }
    @IBOutlet weak var ingredientName: UITextField!
    @IBOutlet weak var slider: UISlider!
    var reference : DatabaseReference!
    var isHidden: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isHidden = true
        checkbox.image = nil
        checkbox.layer.borderColor = UIColor.black.cgColor
        checkbox.layer.borderWidth = 1
        let checkGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(checkBox(touch:)))
        checkGesture.numberOfTapsRequired = 1
        self.checkboxText.addGestureRecognizer(checkGesture)
        reference = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ingredientName.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ingredientName.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func checkBox(touch:UITapGestureRecognizer) {
        if (isHidden!) {
            checkbox.image = UIImage(named: "Checkmark")
            isHidden = false
            slider.isHidden = true
            amount.text = "Any"
        }
        else {
            checkbox.image = nil
            isHidden = true
            slider.isHidden = false
            if (type.selectedSegmentIndex == 0) {
                amount.text = String("\(Int(slider.value)) oz.")
            }
            else {
                amount.text = String(Int(slider.value))
            }
        }
    }
    
    
    @IBAction func changeAmount(_ sender: Any) {
        let newAmount: Int = Int(slider.value)
        if (type.selectedSegmentIndex == 0) {
            amount.text = String("\(newAmount) oz.")
        }
        else {
            amount.text = String(newAmount)
        }
    }
    
    func showAlertName() {
        let alert = UIAlertController(title: "Uh Oh!", message: "You cannot add an empty ingredient name. Please write something!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertAmount() {
        let alert = UIAlertController(title: "Uh Oh!", message: "You must specify a non-zero amount to your ingredient! If you wish to skip that, select skip amount.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "doneSegue") {
            if ((ingredientName.text?.isEmpty)!) {
                showAlertName()
                return false
            }
            else if (slider.value == slider.minimumValue && isHidden!) {
                showAlertAmount()
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "doneSegue") {
            if (ingredientName.text?.contains(" "))! {
                ingredientName.text = ingredientName.text?.replacingOccurrences(of: " ", with: "")
                print(ingredientName.text!)
            }
            let ingredient = (ingredientName.text, amount.text)
            FridgeTableViewController.ingredientList.addIngredient(newIng: ingredient as! (String, String))
            let userID = Auth.auth().currentUser?.uid
            self.reference.child("Users").child(userID!).child("ingredients").child(ingredientName.text!)
            self.reference.child("Users/\(userID!)/ingredients/\(ingredientName.text!)").setValue(amount.text!)
        }
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
