//
//  HomeScreenWebKitViewController.swift
//  TableView
//
//  Created by Khutjo MAPUTLA on 2019/10/24.
//  Copyright © 2019 Khutjo MAPUTLA. All rights reserved.
//

import UIKit
import WebKit

class HomeScreenWebKitViewController: UIViewController, UITextFieldDelegate{

    let CUSTOMER_KEY = "e9d230cff1ad703075b3522dfe8a6631abedeeab537e113781f49b98ea2b7aa6"
    let CUSTOMER_SECRET = "db893a6df9ac4185f60bdd7a24fb39bbb70d6eed704d42f37228ea0916f5ec50"



    @IBOutlet weak var searchField: UITextField!
    @IBAction func search(_ sender: UIButton) {
        self.makeIntraRequest(requestBody: searchField.text!)
        print(searchField.text!)
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background_login-a4e0666f73c02f025f590b474b394fd86e1cae20e95261a6e4862c2d0faa1b04")!)
        justget()
    }
    func ShowErrorAlet(error_T: String, error_m: String){
        let alert = UIAlertController(title: error_T, message: error_m, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
//        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    func decodeProfileData(){
        
        
        
    }
    
    func makeIntraRequest(requestBody: String) {
        let urlGetUserInfo = "https://api.intra.42.fr/v2/users/" + requestBody
        var request: NSMutableURLRequest?
        if let urlForAPI = NSURL(string: urlGetUserInfo) {
            request = NSMutableURLRequest(url: urlForAPI as URL)
            request?.httpMethod = "GET"
            
            request?.setValue("Bearer " + Dataridge.myobj.getToken(), forHTTPHeaderField: "Authorization")
        }
        else {
            return
        }
        let task = URLSession.shared.dataTask(with: request! as URLRequest)
        {
            (data, response, error) in
            if error != nil {
                print("hi")
            }else if let userData = data {
                do {if let dic : NSDictionary = try JSONSerialization.jsonObject(with: userData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print(dic)
                        
                    
                        if let projects = dic["projects_users"] {
//                                print(projects)
//                              print (type(of: dic["projects_users"]))
                                DispatchQueue.main.async {
                                Dataridge.myobj.setProfiledat(profiledat: projects)
                                self.performSegue(withIdentifier: "SecondViewController", sender: self)
                            }
                        }
                        else {
                            print("nopedy nope")
                                DispatchQueue.main.async {
                                    self.ShowErrorAlet(error_T: "Profile Not Found", error_m: "The profile your looking seem to not exist check spelling and try again")
                            }
                        }
                    }
                }
                catch (let err) {
                   print(err)
                }
            }
        }
        task.resume()
    }

    func justget(){
        let BEARER = ((CUSTOMER_KEY + ":" + CUSTOMER_SECRET).data(using: String.Encoding.utf8, allowLossyConversion: true)?.base64EncodedString(options: NSData.Base64EncodingOptions (rawValue: 0)))
        let url_tokens = "https://api.intra.42.fr/oauth/token"
        let url_k = NSURL(string: url_tokens)!
        let request = NSMutableURLRequest(url: url_k as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + BEARER!, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8, allowLossyConversion: false)
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {
            (data, response, error) in
            if error != nil {
                print(error ?? "")
                self.ShowErrorAlet(error_T: "API response error", error_m: "Unable to connect")
            }
            else if let d = data {
                    do {if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            print(dic)
//                            print(dic.object(forKey: "access_token") as? Any)
                            Dataridge.myobj.settoken(token: (dic.object(forKey: "access_token") as? String)!)
                    }
                }
                catch (let err) {
                    self.ShowErrorAlet(error_T: "API response error", error_m: "Token noe recived")
                    print(err)
                }
            }
        }
        task.resume()
    }
}
