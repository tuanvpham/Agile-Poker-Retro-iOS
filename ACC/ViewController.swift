//
//  ViewController.swift
//
//
//  Created by Leonardo Araque on 11/22/18.
//  Copyright © 2018 Leonardo Araque. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController, UITextFieldDelegate {
    
    struct messageStruct : Codable{
        var userId : Int
        var id : Int
        var title : String
        var completed : Bool
    }
    
    struct usernamePass : Codable {
        var email: String
        var password: String
    }
    
    struct loginReturn : Codable{
        var token: String
        var email: String
        var username: String
    }
    
    @IBOutlet weak var imageContainer: UIImageView!
    @IBOutlet weak var displayText: UILabel!
    
    @IBOutlet weak var inputPassword: UITextField!
    
    @IBAction func inputProcess(_ sender: UIButton) {
        login()
        print("ran")
    }
    @IBAction func bypassLogin(_ sender: Any) {
        byPassLogin()
    }
    @IBOutlet weak var inputEmail: UITextField!
    
    var webAuthSession :ASWebAuthenticationSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        inputPassword.delegate = self
        inputEmail.delegate = self
        
        
        
        let imageURL = URL(string: "https://www.ucf.edu/brand/files/2016/07/UCF-Tab-Signature-lockup_vertical-KG-7406.png")!
        let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            if (error == nil){
                
                let loadedImage = UIImage(data: data!)
                DispatchQueue.main.async {
                    self.imageContainer.image = loadedImage
                }
            }
        }
        task.resume()
    
        let ws = WebSocket("ws://localhost:8000/lobby/title/?abaeous@knights.ucf.edu")
        print("testing")
        ws.event.close = {(Code: Int, Reason: String, Clean: Bool) -> Void in print(Reason)}
        ws.event.open = {
            print("opened")
            var jsonSend = Models.lobby()
            jsonSend.has_joined = "abaeous@knights.ucf.edu"
            jsonSend.player = "abaeous@knights.ucf.edu"
            let encoder = JSONEncoder()
            var sendingThis = try! encoder.encode(jsonSend)
            //var sendingString = "{\"itemType\" : \"what_went_well\", \"itemText\" : \"something went well\"}"
            let formatedJson = String(data: sendingThis, encoding: String.Encoding.utf8)
            ws.send(formatedJson)
            //ws.send("{\"test\":\"something\"}")

        }

        ws.event.message = {(message: Any) -> Void in
            print("some message")
            if let text = message as? String {
                print("something received")
                print("From Django: \(text)")
            }
        }
 
//        var ws: WebSocket? = nil
//        ws = WebSocket("ws://localserver:8000/lobby/title/?abaeous@knights.ucf.edu")
//        ws!.event.close = {(Code: Int, Reason: String, Clean: Bool) -> Void in print(Reason)}
//        ws!.event.open = {
//            print("opened")
//            let sendThisUserJoined = Models.lobby()
//            sendThisUserJoined.has_joined = "abaeous@knights.ucf.edu"
//            sendThisUserJoined.player = "abaeous@knights.ucf.edu"
//            let encoder = JSONEncoder()
//            let sendingThis = try! encoder.encode(sendThisUserJoined)
//            //            var sendingString = "{\"itemType\" : \"what_went_well\", \"itemText\" : \"something went well\"}"
//            let formatedJson = String(data: sendingThis, encoding: String.Encoding.utf8)
//            ws!.send(formatedJson)
//        }
//
//        ws!.event.message = {(message: Any?) throws -> Void in
//            print("some message")
//            let decoder = JSONDecoder()
//            let decodedMessage = try! decoder.decode(Models.lobby.self, from: message as! Data)
//            catch{
//                fatalError("this is bullshit")
//            }
//            switch decodedMessage.type {
//            case "has_joined":
//                print(decodedMessage.type)
//            default:
//                print("this type isn't valid")
//            }
//
//        }
        
        
        

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    
    func login(){
        
        inputEmail.text = "abaeous@knights.ucf.edu"
        inputPassword.text = "onetwothree"
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/login/")!)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        //let inpuT = usernamePass(email: "tuanvpham32@outlook.com", password: "Pviett#8613")
        //let inpuT = Models.LoginInput(email: inputEmail.text! as String, password: inputPassword.text! as String)
        //print(inpuT)
        //print(input2)
        
        //let encoder = JSONEncoder();
        //request.httpBody = try! encoder.encode(inpuT)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do{
                let decoder = JSONDecoder()
                let responseJson = try decoder.decode(Models.LoginOutput.self, from: data!)
                DispatchQueue.main.async {
                    print(responseJson.oauth_url + "\n")
                    print(responseJson.oauth_token + "\n")
                    print(responseJson.oauth_token_secret + "\n")

                    let usrDefaults = UserDefaults.standard
                    usrDefaults.set(responseJson.oauth_url, forKey: "oauth_url")
                    usrDefaults.set(responseJson.oauth_token, forKey: "oauth_token")
                    usrDefaults.set(responseJson.oauth_token_secret, forKey: "oauth_token_secret")
                    self.getAuthTokenWithWebLogin()
                }
                
            } catch{
                print(error)
            }
            
        }).resume()
    }
    
    func byPassLogin(){
        let viewController:UIViewController = UIStoryboard(name: "Sessions", bundle: nil).instantiateViewController(withIdentifier: "SessionSettings") as UIViewController
        
        self.present(viewController, animated: false, completion: nil)
    }
    
    func getAuthTokenWithWebLogin() {
        var urlString: String = UserDefaults.standard.string(forKey: "oauth_url")!
        if let splitIndex = urlString.firstIndex(of: "&"){
            urlString = String(urlString[..<splitIndex])
        }
        print(urlString)
        

        let authURL = URL(string: urlString + "&oauth_callback=acc://")
        let callbackUrlScheme = ""
        let authCallback = "http://localhost:8000/oauth_user?oauth_token_secret=" + UserDefaults.standard.string(forKey: "oauth_token_secret")!
        
        self.webAuthSession = ASWebAuthenticationSession.init(url: authURL!, callbackURLScheme: callbackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in
            
            // handle auth response
            guard error == nil, let successURL = callBack else {
                return
            }
            self.finalizeLoginUsingToken(oauth_token: UserDefaults.standard.string(forKey: "oauth_token")!, oauth_secret: UserDefaults.standard.string(forKey: "oauth_token_secret")!)
 
        })
        
        // Kick it off
        self.webAuthSession?.start()

    }
    
    func finalizeLoginUsingToken(oauth_token: String, oauth_secret: String){
        let bodyInput = Models.jiraAuthInput(token: oauth_token, secret: oauth_secret)
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/oauth_user/")!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(bodyInput)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do{
                let decoder = JSONDecoder()
                let responseJson = try decoder.decode(Models.jiraAuthOutput.self, from: data!)
                DispatchQueue.main.async {
                    print(responseJson.message + "\n")
                    print(responseJson.token + "\n")
                    print(responseJson.email + "\n")
                    print(responseJson.username + "\n")
                    print(responseJson.access_token + "\n")
                    print(responseJson.secret_access_token + "\n")
                    
                    let usrDefaults = UserDefaults.standard
                    usrDefaults.set(responseJson.token, forKey: "token")
                    usrDefaults.set(responseJson.access_token, forKey: "access_token")
                    usrDefaults.set(responseJson.email, forKey: "email")
                    usrDefaults.set(responseJson.username, forKey: "username")
                    
                    let viewController:UIViewController = UIStoryboard(name: "Sessions", bundle: nil).instantiateViewController(withIdentifier: "SessionNavigation") as UIViewController
                    
                    self.present(viewController, animated: false, completion: nil)
                }
                
            } catch{
                print(error)
            }
            
        }).resume()
    }
}
