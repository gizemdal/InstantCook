//
//  PreviousRecipes.swift
//  InstantCook
//
//  Created by Gizem Dal on 4/4/18.
//  Copyright © 2018 CIS195. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class FavoritedRecipes: UITableViewController {

    @IBOutlet var favoriteList: UITableView!
    var recipes : [String]!
    var recipeInfo : Recipe?
    var reference : DatabaseReference!
    var databaseHandle : DatabaseHandle!
    override func viewDidLoad() {
        super.viewDidLoad()
        recipes = []
        reference = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        databaseHandle = reference.child("Users").child(userID!).observe(.childAdded, with: { (snapshot) in
            if (snapshot.key == "recipes") {
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let ingName = snap.key
                    if (!self.recipes.contains(ingName)) {
                        self.recipes.append(ingName)
                    }
                }
                self.favoriteList.reloadData()
            }
            
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteList.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
        let number = recipes.count
        cell.textLabel?.text = recipes[number - indexPath.row - 1]
        cell.textLabel?.font = UIFont(name: "Bodoni 72", size: 18)!
        return cell
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
