//
//  HomeScreenViewController.swift
//  InstantCook
//
//  Created by Gizem Dal on 4/3/18.
//  Copyright © 2018 CIS195. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var defaultView: UIView!
    @IBOutlet weak var recipeView: UIView!
    @IBOutlet weak var nameDefault: UILabel!
    @IBOutlet weak var nameRecipe: UILabel!
    @IBAction func logOut(_ sender: UIButton) {
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "logoutSegue", sender: self)
        print("user logged out successfully")
    }
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var recipeTitle: UITextView!
    @IBOutlet weak var sideMenuRecipe: menuAnimation!
    @IBOutlet weak var sideMenuDefault: menuAnimation!
    var noRecipes : Bool!
    var reference: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    
    static var menuOpen: Bool = false
    @IBAction func menuTapped(_ sender: UIBarButtonItem) {
        if (HomeScreenViewController.menuOpen) {
            HomeScreenViewController.menuOpen = false
            if (noRecipes) {
            sideMenuDefault.slideBack(x: -85, view: sideMenuDefault)
            }
            else {
            sideMenuRecipe.slideBack(x: -85, view: sideMenuRecipe)
            }
        }
        else {
            HomeScreenViewController.menuOpen = true
            if (noRecipes) {
                sideMenuDefault.slideFront(x: 85, view: sideMenuDefault)
            }
            else {
                sideMenuRecipe.slideFront(x: 85, view: sideMenuRecipe)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = Auth.auth().currentUser?.uid
        reference = Database.database().reference()
        databaseHandle = reference.child("Users").child(userID!).observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            let name = postDict["name"] as? String ?? ""
            let recipeStatus = postDict["recipes"] as? NSDictionary
            if (recipeStatus == nil) {
                self.noRecipes = true
                self.nameDefault.text = "Hi \(name)!"
            }
            else {
                self.noRecipes = false
                self.nameRecipe.text = "Hi \(name)!"
            }
            if (self.noRecipes) {
                self.defaultView.isHidden = false
                self.recipeView.isHidden = true
            }
            else {
                var id : Int = 0
                let lower : UInt32 = 0
                let upper : UInt32 = UInt32((recipeStatus?.count)!)
                let randomNumber = arc4random_uniform(UInt32(upper - lower)) + lower
                var counter = 0
                for recipe in recipeStatus! {
                    if (counter == randomNumber) {
                        id = recipe.value as! Int
                        break
                    }
                    counter = counter + 1
                }
                self.defaultView.isHidden = true
                self.recipeView.isHidden = false
               
                let website = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/\(id)/similar")
                var request = URLRequest(url: website!)
                request.httpMethod = "GET"
                let config = URLSessionConfiguration.default
                config.httpAdditionalHeaders = ["X-Mashape-Key" : "nH66rXDU7PmshjON9LTO1IMedQIRp1FOS4Gjsn0djewDWum4sS", "Accept" : "application/json"]
                let session = URLSession.init(configuration: config)
                session.dataTask(with: request) {data,response,error in
                    if let data = data {
                        let result = try! JSONSerialization.jsonObject(with: data, options: [])
                        let dict1 = result as? NSArray
                        let dict2 = dict1![0] as? NSDictionary
                        let title = dict2! ["title"]! as? String
                        let image = dict2! ["image"] as? String
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.recipeTitle.text = title
                            let urlText = "https://spoonacular.com/recipeImages/\(image!)"
                            if (!urlText.contains("{") && !urlText.contains("}")) {
                                let url: NSURL = NSURL(string: urlText)!
                                let data: NSData = try! NSData(contentsOf: url as URL)
                                self.recipeImg.image = UIImage(data: data as Data)
                            }
                            else {
                                self.recipeImg.image = #imageLiteral(resourceName: "instantCook2")
                            }
                        })
                    }
                    }.resume()
            }
        })
        HomeScreenViewController.menuOpen = false
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
