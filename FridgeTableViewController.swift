//
//  FridgeTableViewController.swift
//  InstantCookProject
//
//  Created by Gizem Dal on 4/17/18.
//  Copyright © 2018 CIS195. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class FridgeTableViewController: UITableViewController {

    static var ingredientList = Fridge()
    @IBOutlet var list: UITableView!
    var reference : DatabaseReference!
    var databaseHandle : DatabaseHandle!
    override func viewDidLoad() {
        super.viewDidLoad()
         FridgeTableViewController.ingredientList.resetIngredients()
        reference = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        databaseHandle = reference.child("Users").child(userID!).observe(.childAdded, with: { (snapshot) in
            if (snapshot.key == "ingredients") {
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let ingName = snap.key
                    let amount = snap.value as? NSString
                    FridgeTableViewController.ingredientList.addIngredient(newIng: (ingName, amount! as String))
                }
                self.list.reloadData()
            }

        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        list.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return FridgeTableViewController.ingredientList.getSize()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        let number = FridgeTableViewController.ingredientList.getSize()
        cell.textLabel?.text = FridgeTableViewController.ingredientList.getIngredients()[number - indexPath.row - 1].0
        cell.textLabel?.font = UIFont(name: "Bodoni 72", size: 18)!
        cell.detailTextLabel?.text = "Amount: \(FridgeTableViewController.ingredientList.getIngredients()[number - indexPath.row - 1].1)"
        cell.detailTextLabel?.font = UIFont(name: "Bodoni 72", size: 12)!
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
