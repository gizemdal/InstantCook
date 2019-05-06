//
//  LookRecipe.swift
//  InstantCookProject
//
//  Created by Gizem Dal on 4/21/18.
//  Copyright © 2018 CIS195. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class LookRecipe: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ingredientData : String!
    var userID : String!
    var reference : DatabaseReference!
    var databaseHandle : DatabaseHandle!
    var recipes : [Recipe]!
    var recipeInfo : Recipe?
    
    @IBOutlet weak var recipeList: UITableView!
    @IBAction func lookBtn(_ sender: UIButton) {
        let urlStr = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/findByIngredients?fillIngredients=false&ingredients=\(ingredientData!)&limitLicense=false&number=10&ranking=1"
        let website = URL(string: urlStr)
        var request = URLRequest(url: website!)
        request.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["X-Mashape-Key" : "nH66rXDU7PmshjON9LTO1IMedQIRp1FOS4Gjsn0djewDWum4sS", "Accept" : "application/json"]
        let session = URLSession.init(configuration: config)
        session.dataTask(with: request) {data,response,error in
            if let data = data {
                let result = try! JSONSerialization.jsonObject(with: data, options: [])
                let dict1 = result as! NSArray
                for items in dict1 {
                    let dict2 = items as? NSDictionary
                    let id = dict2! ["id"]! as? Int
                    let image = dict2! ["image"]! as? String
                    let title = dict2! ["title"]! as? String
                    let missedIngredients = dict2! ["missedIngredientCount"]! as? Int
                    let usedIngredients = dict2! ["usedIngredientCount"]! as? Int
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.recipes.append(Recipe(title: title!, id: id!, image: image!, used: usedIngredients!, missing: missedIngredients!))
                        self.recipeList.reloadData()
                    })
                }
            }
            }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipes = []
        recipeList.dataSource = self
        recipeList.delegate = self
        ingredientData = ""
        reference = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        var isFirst = true
        databaseHandle = reference.child("Users").child(userID!).observe(.childAdded, with: { (snapshot) in
            if (snapshot.key == "ingredients") {
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let ingredientName = snap.key
                    if (isFirst) {
                        self.ingredientData.append(ingredientName.lowercased())
                        isFirst = false
                    }
                    else {
                        self.ingredientData.append("%2C\(ingredientName.lowercased())")
                    }
                }
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
        recipeList.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        let number = recipes.count
        cell.textLabel?.text = recipes[indexPath.row].getTitle()
        if (recipes[number - indexPath.row - 1].getMissingCount() == 0) {
           cell.textLabel?.textColor = UIColor.green
        }
        else {
            cell.textLabel?.textColor = UIColor.orange
        }
        cell.textLabel?.font = UIFont(name: "Bodoni 72", size: 17)!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipeInfo = recipes[indexPath.row]
        performSegue(withIdentifier: "cardSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "cardSegue") {
            if let destination = segue.destination as?
                RecipeCard {
                destination.recipe = recipeInfo
            }
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
