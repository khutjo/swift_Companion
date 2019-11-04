//
//  LoginScreen.swift
//  TableViewTests
//
//  Created by Khutjo MAPUTLA on 2019/10/25.
//  Copyright © 2019 Khutjo MAPUTLA. All rights reserved.
//

    import UIKit
    import WebKit

    class LoginScreen: UIViewController, WKNavigationDelegate{
        

        @IBOutlet weak var webView: WKWebView!
        
        let HOST = "www.stackoverflow.com"
        let CUSTOMER_KEY = "e9d230cff1ad703075b3522dfe8a6631abedeeab537e113781f49b98ea2b7aa6"
        let CUSTOMER_SECRET = "db893a6df9ac4185f60bdd7a24fb39bbb70d6eed704d42f37228ea0916f5ec50"
    //    https://api.intra.42.fr/oauth/authorize?client_id=e9d230cff1ad703075b3522dfe8a6631abedeeab537e113781f49b98ea2b7aa6&redirect_uri=https%3A%2F%2Fwww.stackoverflow.com&response_type=code/
        func gohome(){
           let url = URL(string: "https://api.intra.42.fr/oauth/authorize?client_id=e9d230cff1ad703075b3522dfe8a6631abedeeab537e113781f49b98ea2b7aa6&redirect_uri=https%3A%2F%2Fwww.stackoverflow.com&response_type=code")
            let request = URLRequest(url: url!)
            webView.load(request)

        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            gohome()
            webView?.navigationDelegate = self
    //        while (Dataridge.myobj.getIsTokenSet() == false){
    //        sleep(4)
    //        }

        }
        
        func loginFail(){
            let alert = UIAlertController(title: "login failed", message: "Retry or Exit", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in self.gohome() }))
            alert.addAction(UIAlertAction(title: "Exit", style: .cancel, handler: { action in exit(0) }))

            self.present(alert, animated: true)

        }
        
        func getQueryStringParameter(url: String, param: String) -> String? {
            if let newUrl = URLComponents(string: url) {
                return newUrl.queryItems?.first(where: { $0.name == param })?.value
            }
            else {
                return (nil)
            }
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping
            (WKNavigationActionPolicy) -> Void) {
            
            let host = navigationAction.request.url?.host
//            print(host)
            if (String(host!) == "www.stackoverflow.com"){print("fuck yeah")}
            if navigationAction.navigationType == .formSubmitted{
                if navigationAction.request.url?.host == HOST{
                    if let code = getQueryStringParameter(url: navigationAction.request.url!.absoluteString, param: "code"){
                        let url = URL(string: "https://api.intra.42.fr/oauth/token")
                        var request = URLRequest(url: url!)
                        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                        request.httpMethod = "POST"
                        let parameters =
                            "grant_type=authorization_code" + "&" +
                            "client_id=" + String(CUSTOMER_KEY) + "&" +
                            "client_secret=" + String(CUSTOMER_SECRET) + "&" +
                            "code=" + String(code) + "&" +
                            "redirect_uri=https://" + String(HOST)
                        request.httpBody = parameters.data(using: String.Encoding.utf8)
                        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                            if let e = error{
                                print(e)
                            }
                            else if let d = data{
                                do {
                                    let jsonData = try JSONSerialization.jsonObject(with: d, options: []) as? [String: Any]
                                    let tok : NSString = (jsonData?["access_token"])! as! NSString
                                    print(tok)
//                                    print(host)
                                    Dataridge.myobj.settoken(token: tok as String)
//                                    DispatchQueue.main.async {
//                                    webView.isHidden = true
//                                   }
                                } catch (let err){
                                    print("\(err)")
                                }
                                print(d)
                            }else{
                                print("No response!")
                            }
                        }
                        task.resume()
                    }
                    if (String(host!) == "www.stackoverflow.com" && Dataridge.myobj.getIsTokenSet() == false){
                        loginFail()
                        print("login failed")
                    }
                    
                    if (Dataridge.myobj.getIsTokenSet()){
                        print("1I GOT IT!!!!!!!!! " + Dataridge.myobj.getToken())
                    }
                    else
                    {print("1shut up")}
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
            
            if (Dataridge.myobj.getIsTokenSet()){
                print("I GOT IT!!!!!!!!!")
            }
            else
            {print("shut up")}
        }

        
    }

   
