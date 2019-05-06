//
//  RecipeCard.swift
//  InstantCookProject
//
//  Created by Gizem Dal on 4/21/18.
//  Copyright © 2018 CIS195. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import WebKit

class RecipeCard: UIViewController, UINavigationControllerDelegate, UIWebViewDelegate {
    
    var recipe : Recipe?
    var reference : DatabaseReference!
    @IBAction func addFavorites(_ sender: Any) {
        var pathName : String?
        let recipeId = recipe?.getId()
        let user = Auth.auth().currentUser?.uid
        if (recipe?.getTitle().contains("."))! {
        pathName = recipe?.getTitle().replacingOccurrences(of: ".", with: "")
        }
        else if (recipe?.getTitle().contains("#"))!{
        pathName = recipe?.getTitle().replacingOccurrences(of: "#", with: "")
        }
        else if (recipe?.getTitle().contains("["))! {
        pathName = recipe?.getTitle().replacingOccurrences(of: "[", with: "")
        }
        else if (recipe?.getTitle().contains("]"))! {
        pathName = recipe?.getTitle().replacingOccurrences(of: "]", with: "")
        }
        else {
            pathName = recipe?.getTitle()
        }
        self.reference.child("Users").child(user!).child("recipes").child("\(pathName ?? " ")")
            self.reference.child("Users/\(user!)/recipes/\(pathName ?? " ")").setValue(recipeId)
            showAdded()
    }
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var summary: UIScrollView!
    @IBOutlet weak var image: UIImageView!
    var summaryText : String!
    var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var pageLoad = true
    override func viewDidLoad() {
        super.viewDidLoad()
        summaryText = ""
        reference = Database.database().reference()
        recipeTitle.text = recipe?.getTitle()
        let url: NSURL = NSURL(string: (recipe?.getImage())!)!
        let data: NSData = try! NSData(contentsOf: url as URL)
        image.image = UIImage(data: data as Data)
        // Do any additional setup after loading the view.
        
        let recipeId : Int = (recipe?.getId())!
        let urlStr = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/\(recipeId)/summary"
        let website = URL(string: urlStr)
        var request = URLRequest(url: website!)
        request.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["X-Mashape-Key" : "nH66rXDU7PmshjON9LTO1IMedQIRp1FOS4Gjsn0djewDWum4sS", "Accept" : "application/json"]
        let session = URLSession.init(configuration: config)
        session.dataTask(with: request) {data,response,error in
            if let data = data {
                let result = try! JSONSerialization.jsonObject(with: data, options: [])
                let dict = result as? NSDictionary
                self.summaryText = dict! ["summary"]! as? String
                DispatchQueue.main.async(execute: {() -> Void in
                    self.frame.origin.x = 0
                    self.frame.size = self.summary.frame.size
                    let subView = UIWebView(frame: self.frame)
                    subView.backgroundColor = UIColor.white
                    subView.delegate = self
                    subView.loadHTMLString(self.summaryText, baseURL: URL(string: ""))
                    self.summary.addSubview(subView)
                })
            }
            }.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        pageLoad = false
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return pageLoad
    }
    
    func showAdded() {
        let alert = UIAlertController(title: "Favorites", message: "This recipe is added to your favorites!", preferredStyle: .alert)
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
